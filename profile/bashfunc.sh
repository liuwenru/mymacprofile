function netportshow { 
netstat -tnup|grep $1 | awk '{print $5 " " $6}' | awk -F: '{print $1  " " $2}' | awk '{print $1 " " $3}'| sort -n | uniq -c; 
} 
function killbystr ()
{
ps aux|grep $1 | grep -v grep | awk '{print $2}'| xargs kill -9
}
function dockerinspectmount {
docker inspect $1 --format '{{ range .Mounts }}{{ .Type }} {{ .Source}} -> {{ .Destination  }} {{ println }}{{end}}'
}

dockersave() {
    local input="$1"
    local save_dir="${2:-.}"

    local image_name safe_name filename output_file

    if [[ -z "$input" ]]; then
        echo "Usage: dockersave <image_name_or_id> [save_dir]" >&2
        return 1
    fi

    # 检查镜像是否存在
    if ! docker inspect "$input" &>/dev/null; then
        echo "Error: image '$input' not found" >&2
        return 1
    fi

    # 创建保存目录
    mkdir -p "$save_dir" || {
        echo "Error: cannot create directory '$save_dir'" >&2
        return 1
    }

    # 优先使用用户输入的 name:tag
    if [[ "$input" == *":"* ]]; then
        image_name="$input"
    else
        local lookup
        lookup=$(docker inspect --format '{{index .RepoTags 0}}' "$input" 2>/dev/null)

        if [[ -z "$lookup" || "$lookup" == "<no value>" ]]; then
            echo "Warning: no name:tag found for '$input', using ID as filename" >&2
            image_name="$input"
        else
            image_name="$lookup"
        fi
    fi

    # 生成安全文件名
    safe_name="${image_name//[\/:@]/_}"
    filename="${safe_name}.tar"
    output_file="${save_dir%/}/$filename"

    echo "Saving '$image_name' → '$output_file' ..."

    if docker save -o "$output_file" "$image_name"; then
        echo "Done: $output_file"
    else
        echo "Error: docker save failed" >&2
        rm -f "$output_file"
        return 1
    fi
}
