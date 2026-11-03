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
  case "${1:-}" in
  -h | --help)
    cat <<'EOF'
用法：dockersave <镜像名或ID> [输出目录]
      dockersave -h | --help

将 Docker 镜像保存为 tar 文件，文件名为 "<镜像名_tag>_<架构>.tar"。

参数：
  镜像名或ID  要保存的镜像（必填），如 nginx:1.25 或镜像 ID
  输出目录    tar 文件保存目录，默认为当前目录 (.)，不存在会自动创建

选项：
  -h, --help  显示本帮助并退出

说明：
  - 文件名中的 / : @ 会被替换为 _
  - 无 name:tag 的镜像（dangling 或纯 ID）使用传入值作为文件名
  - 保存成功后文件权限设为 644
  - 保存失败时会删除不完整的输出文件

示例：
  dockersave nginx:1.25             # 生成 ./nginx_1.25_amd64.tar
  dockersave nginx:1.25 /data/images
EOF
    return 0
    ;;
  esac

  local input="$1"
  local outdir="${2:-.}"
  local image_name architecture safe_name safe_arch filename lookup

  if [[ -z "$input" ]]; then
    echo "Usage: dockersave <image_name_or_id> [output_dir]" >&2
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

  mkdir -p -- "$outdir" || return 1
  outdir=$(cd -- "$outdir" && pwd -P) || return 1
  filename="${outdir%/}/${safe_name}_${safe_arch}.tar"

  echo "Image:        $image_name"
  echo "Architecture: $architecture"
  echo "Output:       $filename"
  echo "Saving..."

  if docker save -o "$filename" "$image_name"; then
    # docker save 生成的文件默认为 600，放宽为 644 方便其他用户读取分发
    if ! chmod 644 -- "$filename"; then
      echo "Error: saved but chmod 644 failed: $filename" >&2
      return 1
    fi
    echo "Done: $filename"
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
  case "${1:-}" in
  -h | --help)
    cat <<'EOF'
用法：killps <进程关键字>
      killps -h | --help

按完整命令行匹配进程（pgrep -f），列出后确认再 kill -9 强制终止。

参数：
  进程关键字  匹配进程完整命令行的关键字或正则（必填）

选项：
  -h, --help  显示本帮助并退出

说明：
  - 列出 PID、用户、运行时长和完整命令，输入 y/Y 才执行终止
  - 会排除当前 shell 自身，避免误杀
  - 部分进程终止失败（如权限不足）时返回非 0

示例：
  killps nginx
  killps 'java.*tomcat'
EOF
    return 0
    ;;
  esac

  local keyword="${1:-}"
  local answer pid pid_list
  local -a pids

  if [[ -z "$keyword" ]]; then
    echo "用法：killps <进程关键字>" >&2
    return 1
  fi

  # 排除当前 shell，避免 bash -c '... killps xxx' 时匹配到自己
  while IFS= read -r pid; do
    [[ -n "$pid" && "$pid" != "$$" ]] && pids+=("$pid")
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
    if kill -9 "${pids[@]}"; then
      echo "已终止 ${#pids[@]} 个进程"
    else
      echo "错误：部分进程终止失败（可能已退出或权限不足）" >&2
      return 1
    fi
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
  case "${1:-}" in
  -h | --help)
    cat <<'EOF'
用法：tarzst [源目录或文件] [输出文件]
      tarzst -h | --help

将目录打包为 tar 并用 zstd 压缩（优先使用 pzstd 多线程）；
源为普通文件时不打 tar，直接 zstd 压缩该文件。

参数：
  源目录或文件  要打包的目录或要压缩的文件，默认为当前目录 (.)
  输出文件      输出路径，默认放在当前目录：
                目录为 "<源目录名>.tar.zst"，文件为 "<文件名>.zst"
                源目录为 / 时默认名为 root.tar.zst
                所在目录不存在会自动创建，文件已存在则报错退出

选项：
  -h, --help  显示本帮助并退出

环境变量：
  PZSTD_THREADS  压缩线程数，默认为 CPU 核数（nproc）

说明：
  - 压缩级别固定为 -3
  - 优先使用 pzstd -p N；没有则退回 zstd -TN
  - 输出文件位于源目录内时，会自动排除压缩包自身
  - 归档内路径以 ./ 开头（相对源目录）
  - 单文件压缩结果可用 untarzst 或 zstd -d 解压
  - 压缩失败时会删除不完整的输出文件

示例：
  tarzst                          # 打包当前目录
  tarzst ~/project                # 生成 ./project.tar.zst
  tarzst ~/project /tmp/p.tar.zst
  tarzst app.log                  # 生成 ./app.log.zst
  PZSTD_THREADS=4 tarzst data
EOF
    return 0
    ;;
  esac

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

  local input="${1:-.}"
  local mode=dir

  if [[ -f "$input" ]]; then
    # 普通文件（含指向文件的软链接）：不走 tar，直接 zstd 压缩
    mode=file
    src=$(cd -- "$(dirname -- "$input")" && pwd -P) || return 1
    src="${src%/}/$(basename -- "$input")"
    name=$(basename -- "$src")
  elif [[ -d "$input" ]]; then
    src=$(cd -- "$input" && pwd -P) || return 1
    name=$(basename -- "$src")
    [[ "$src" == / ]] && name=root
  else
    echo "错误：源路径不存在或不是普通文件/目录：$input" >&2
    return 1
  fi

  if [[ ! -r "$src" ]]; then
    echo "错误：源路径不可读：$src" >&2
    return 1
  fi

  if [[ "$mode" == file ]]; then
    out=${2:-"$name.zst"}
  else
    out=${2:-"$name.tar.zst"}
  fi
  mkdir -p -- "$(dirname -- "$out")" || return 1
  outdir=$(cd -- "$(dirname -- "$out")" && pwd -P) || return 1
  out="${outdir%/}/$(basename -- "$out")"

  # 提前拒绝已存在的文件，避免下面失败清理时误删旧文件
  if [[ -e "$out" ]]; then
    echo "错误：输出文件已存在：$out" >&2
    return 1
  fi

  # 输出文件位于源目录内时，排除压缩包自身
  case "$out" in
  "${src%/}/"*)
    excludes=(--exclude="./${out#"${src%/}/"}")
    ;;
  esac

  echo "使用 $tool 压缩，线程数：${threads}，输出：$out" >&2

  if [[ "$mode" == file ]]; then
    # 从 stdin 读入，避免不同版本 pzstd/zstd 对文件名参数解析的差异
    if "${compressor[@]}" -3 -o "$out" <"$src"; then
      echo "完成：$out" >&2
    else
      echo "错误：压缩失败，已删除不完整的输出文件" >&2
      rm -f -- "$out"
      return 1
    fi
    return 0
  fi

  if tar -C "$src" "${excludes[@]}" -cf - . |
    "${compressor[@]}" -3 -o "$out"; then
    echo "完成：$out" >&2
  else
    echo "错误：压缩失败，已删除不完整的输出文件" >&2
    rm -f -- "$out"
    return 1
  fi
)

untarzst() (
  case "${1:-}" in
  -h | --help)
    cat <<'EOF'
用法：untarzst 压缩包 [目标目录]
      untarzst -h | --help

解压 .tar.zst 压缩包（优先使用 pzstd 多线程）；
也支持 tarzst 对单个文件生成的 .zst，解压出该文件。

参数：
  压缩包      要解压的 .tar.zst 或单文件 .zst（必填）
  目标目录    解压到的目录，默认为当前目录 (.)，不存在会自动创建

选项：
  -h, --help  显示本帮助并退出

环境变量：
  PZSTD_THREADS  pzstd 解压线程数，默认为 CPU 核数（nproc）

说明：
  - 有 pzstd 时用 pzstd -p N 解压
  - 只有 zstd 时为单线程解码（zstd 解压不支持多线程）
  - 按解压后内容判断是否为 tar，与扩展名无关
  - 单文件解压为 "<目标目录>/<去掉 .zst 的文件名>"，无 .zst 后缀时追加 .out
    输出文件已存在则报错退出，解压失败时删除不完整的输出文件

示例：
  untarzst project.tar.zst
  untarzst project.tar.zst /tmp/restore
  untarzst app.log.zst            # 生成 ./app.log
EOF
    return 0
    ;;
  esac

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
  dest=$(cd -- "$dest" && pwd -P) || return 1

  if [[ "$tool" == pzstd ]]; then
    echo "使用 pzstd 解压，线程数：${threads}，目标：$dest" >&2
  else
    echo "使用 zstd 解压，单线程解码，目标：$dest" >&2
  fi

  # 按内容判断是否为 tar：tar 头偏移 257 处为 "ustar"（POSIX 与 GNU 格式均有）
  # 只解压开头几百字节，用 dd 跳过可能含 NUL 的前部，避免命令替换丢弃 NUL
  local magic name out
  magic=$(
    "${decompressor[@]}" -d -c <"$1" 2>/dev/null |
      dd bs=1 skip=257 count=5 2>/dev/null
  )

  if [[ "$magic" != ustar ]]; then
    # 单文件 .zst：解压为 "<目标目录>/<去掉 .zst 后缀的文件名>"
    name=$(basename -- "$1")
    case "$name" in
    *.zst) name=${name%.zst} ;;
    *) name="$name.out" ;;
    esac
    out="${dest%/}/$name"

    # 提前拒绝已存在的文件，避免下面失败清理时误删旧文件
    if [[ -e "$out" ]]; then
      echo "错误：输出文件已存在：$out" >&2
      return 1
    fi

    echo "检测到非 tar 内容，按单文件解压：$out" >&2

    if "${decompressor[@]}" -d -o "$out" <"$1"; then
      echo "完成：$out" >&2
    else
      echo "错误：解压失败，已删除不完整的输出文件" >&2
      rm -f -- "$out"
      return 1
    fi
    return 0
  fi

  if "${decompressor[@]}" -d -c -- "$1" |
    tar -C "$dest" -xf -; then
    echo "完成：$dest" >&2
  else
    echo "错误：解压失败，目标目录中可能残留部分文件：$dest" >&2
    return 1
  fi
)
