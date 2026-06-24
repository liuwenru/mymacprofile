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
    local image_name safe_name filename

    if [[ -z "$input" ]]; then
        echo "Usage: dockersave <image_name_or_id>" >&2
        return 1
    fi

    # 1. 检查镜像是否存在
    if ! docker inspect "$input" &>/dev/null; then
        echo "Error: image '$input' not found" >&2
        return 1
    fi

    # 2. 核心修复：优先使用用户传入的参数作为保存标识
    # 如果用户传入了 myapp:v2，直接使用它，避免 inspect 解析出错误的旧标签
    if [[ "$input" == *":"* ]]; then
        image_name="$input"
    else
        # 3. 如果传入的是纯 ID (无冒号)，尝试获取其 RepoTags
        local lookup
        lookup=$(docker inspect --format '{{index .RepoTags 0}}' "$input" 2>/dev/null)

        if [[ -z "$lookup" || "$lookup" == "<no value>" ]]; then
            echo "Warning: no name:tag found for '$input', using ID as filename" >&2
            image_name="$input"
        else
            image_name="$lookup"
        fi
    fi

    # 4. 将 : / @ 替换为 _ 生成安全文件名
    safe_name="${image_name//[\/:@]/_}"
    filename="${safe_name}.tar"

    echo "Saving '$image_name' → '$filename' ..."
    if docker save -o "$filename" "$image_name"; then
        echo "Done: $(pwd)/$filename"
    else
        echo "Error: docker save failed" >&2
        rm -f "$filename"
        return 1
    fi
}
