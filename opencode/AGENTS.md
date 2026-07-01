# 工作时的一些配置和预定

- 网络环境
对于一些网络资源如果直接链接不生效时可以使用如下命令配置代理访问 
```bash
if [[ $SHELL == "/bin/bash" ]];then set +o history; fi  && export http_proxy=http://192.168.188.8:1080 && export https_proxy=${http_proxy} && export no_proxy="*.epoint.com.cn,*.aliyun.*,192.168.0.0/16,172.0.0.0/8,127.0.0.1" &&  if [[ $SHELL == "/bin/bash" ]];then set -o history; fi
```

- git的commit 和 push 操作请不要做，我需要人工去做

- 文件读取
一些配置文件每轮回答前建议重新读取一次再回答我的问题
