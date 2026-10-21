function netportshow {
  netstat -tnup | grep $1 | awk '{print $5 " " $6}' | awk -F: '{print $1  " " $2}' | awk '{print $1 " " $3}' | sort -n | uniq -c
}
function killbystr() {
  ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
}
function dockerinspectmount {
  docker inspect $1 --format '{{ range .Mounts }}{{ .Type }} {{ .Source}} -> {{ .Destination  }} {{ println }}{{end}}'
}

dockersave() {
  local input="$1"
  local image_name architecture safe_name safe_arch filename lookup

  if [[ -z "$input" ]]; then
    echo "Usage: dockersave <image_name_or_id>" >&2
    return 1
  fi

  # 明确检查 Docker 镜像，避免同名容器被 docker inspect 匹配
  if ! docker image inspect "$input" &>/dev/null; then
    echo "Error: image '$input' not found" >&2
    return 1
  fi

  # 获取镜像架构，例如 amd64、arm64
  architecture=$(
    docker image inspect \
      --format '{{.Architecture}}' \
      "$input" 2>/dev/null
  )

  if [[ -z "$architecture" || "$architecture" == "<no value>" ]]; then
    echo "Warning: unable to determine architecture, using 'unknown'" >&2
    architecture="unknown"
  fi

  # 尝试获取第一个 RepoTag
  lookup=$(
    docker image inspect \
      --format '{{index .RepoTags 0}}' \
      "$input" 2>/dev/null
  )

  if [[ -z "$lookup" || "$lookup" == "<no value>" ]]; then
    # dangling 镜像或纯 ID
    image_name="$input"
    echo "Warning: no name:tag found for '$input', using ID as filename" >&2
  else
    image_name="$lookup"
  fi

  # 将可能影响文件路径的字符替换为下划线
  safe_name="${image_name//[\/:@]/_}"
  safe_arch="${architecture//[\/:@]/_}"

  filename="${safe_name}_${safe_arch}.tar"

  echo "Image:        $image_name"
  echo "Architecture: $architecture"
  echo "Output:       $filename"
  echo "Saving..."

  if docker save -o "$filename" "$image_name"; then
    echo "Done: $(pwd)/$filename"
  else
    echo "Error: docker save failed" >&2
    rm -f -- "$filename"
    return 1
  fi
}

iptdump() { for t in filter nat mangle raw security; do
  printf -- "-------------  %s  -------------\n" "$t"
  iptables -t "$t" --list --line-number -n -v
done; }
iptsave() { for t in filter nat mangle raw; do
  printf -- "-------------  %s  -------------\n" "$t"
  iptables-save -t "$t" -c
done; }

killps() {
  local keyword="${1:-}"
  local answer pid pid_list
  local -a pids

  if [[ -z "$keyword" ]]; then
    echo "用法: killps <进程关键字>"
    return 1
  fi

  while IFS= read -r pid; do
    [[ -n "$pid" ]] && pids+=("$pid")
  done < <(pgrep -f -- "$keyword")

  if [[ ${#pids[@]} -eq 0 ]]; then
    echo "没有找到包含关键字 '$keyword' 的进程"
    return 0
  fi

  pid_list="$(printf '%s,' "${pids[@]}")"
  pid_list="${pid_list%,}"

  echo "找到以下进程："
  ps -p "$pid_list" -o pid,user,etime,command

  echo
  printf "确认强制终止这些进程？[y/N] "
  IFS= read -r answer

  case "$answer" in
  y | Y)
    kill -9 "${pids[@]}"
    echo "已执行终止操作"
    ;;
  *)
    echo "已取消"
    ;;
  esac
}

tsrun() (
  set -o pipefail
  stdbuf -oL -eL "$@" 2>&1 |
    gawk '{
            printf "%s %s\n", strftime("%Y-%m-%d %H:%M:%S"), $0
            fflush()
        }'
)

sarfull() {
  LC_ALL=C S_TIME_FORMAT=ISO S_COLORS=never \
    stdbuf -oL sar "$@" |
    gawk '
        /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/ {
            print strftime("%Y-%m-%d"), $0
            fflush()
            next
        }
        { print; fflush() }
    '
}

repeat_header() {
  local line=0

  if [[ ${1-} == "-l" ]]; then
    line=${2-}
    if [[ ! $line =~ ^[1-9][0-9]*$ ]]; then
      echo "用法：repeat_header [-l 行号] 命令 [参数...]" >&2
      return 2
    fi
    shift 2
  fi

  "$@" | awk -v line="$line" '
        !found {
            if ((line == 0 && /[^[:space:]]/) ||
                (line > 0 && NR == line)) {
                header = $0
                found = 1
            }
            print
            next
        }
        {
            if (count > 0 && count % 10 == 0)
                print header
            print
            count++
        }
    '
}

tarzst() (
  set -o pipefail

  local src name out outdir threads tool
  local -a excludes=()
  local -a compressor=()

  threads=${PZSTD_THREADS:-$(
    nproc 2>/dev/null ||
      busybox nproc 2>/dev/null ||
      echo 1
  )}

  case "$threads" in
  '' | *[^0-9]*)
    echo "错误：线程数必须是正整数。" >&2
    return 2
    ;;
  esac

  if [[ "$threads" =~ ^0+$ ]]; then
    echo "错误：线程数必须大于 0。" >&2
    return 2
  fi

  if command -v pzstd >/dev/null 2>&1; then
    tool=pzstd
    compressor=(pzstd -p "$threads")
  elif command -v zstd >/dev/null 2>&1; then
    tool=zstd
    compressor=(zstd "-T$threads")
  else
    echo "错误：未找到 pzstd 或 zstd，请安装其中一个。" >&2
    return 1
  fi

  src=$(cd -- "${1:-.}" && pwd -P) || return 1
  name=$(basename -- "$src")
  [[ "$src" == / ]] && name=root

  out=${2:-"$name.tar.zst"}
  outdir=$(cd -- "$(dirname -- "$out")" && pwd -P) || return 1
  out="${outdir%/}/$(basename -- "$out")"

  # 输出文件位于源目录内时，排除压缩包自身
  case "$out" in
  "${src%/}/"*)
    excludes=(--exclude="./${out#"${src%/}/"}")
    ;;
  esac

  echo "使用 $tool 压缩，线程数：$threads，输出：$out" >&2

  tar -C "$src" "${excludes[@]}" -cf - . |
    "${compressor[@]}" -3 -o "$out"
)

untarzst() (
  set -o pipefail

  if [[ -z ${1:-} ]]; then
    echo "用法：untarzst 压缩包 [目标目录]" >&2
    return 2
  fi

  local dest="${2:-.}"
  local threads tool
  local -a decompressor=()

  threads=${PZSTD_THREADS:-$(
    nproc 2>/dev/null ||
      busybox nproc 2>/dev/null ||
      echo 1
  )}

  case "$threads" in
  '' | *[^0-9]*)
    echo "错误：线程数必须是正整数。" >&2
    return 2
    ;;
  esac

  if [[ "$threads" =~ ^0+$ ]]; then
    echo "错误：线程数必须大于 0。" >&2
    return 2
  fi

  if command -v pzstd >/dev/null 2>&1; then
    tool=pzstd
    decompressor=(pzstd -p "$threads")
  elif command -v zstd >/dev/null 2>&1; then
    tool=zstd
    decompressor=(zstd)
  else
    echo "错误：未找到 pzstd 或 zstd，请安装其中一个。" >&2
    return 1
  fi

  if [[ -f "$1" && -r "$1" ]]; then
    :
  else
    echo "错误：压缩包不存在或不可读：$1" >&2
    return 1
  fi

  mkdir -p -- "$dest" || return 1

  if [[ "$tool" == pzstd ]]; then
    echo "使用 pzstd 解压，线程数：$threads，目标：$dest" >&2
  else
    echo "使用 zstd 解压，单线程解码，目标：$dest" >&2
  fi

  "${decompressor[@]}" -d -c -- "$1" |
    tar -C "$dest" -xf -
)
