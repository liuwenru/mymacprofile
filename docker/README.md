# 常用 Docker 配置方法

## 配置 docker 镜像加速

```bash
Shell> vim /etc/docker/daemon.json
{
    "registry-mirrors":["https://docker.mirrors.ustc.edu.cn","https://hub-mirror.c.163.com","https://registry.docker-cn.com"]
}

```

## 待解决问题

不知道是不是 docker moby 的 bug，在 fedora32 等机器上需要配置如下配置才可以加速构建速度
https://github.com/moby/moby/issues/38814

```json
"default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 65535,
      "Soft": 65535
    },
    "nproc": {
      "Name": "nproc",
      "Soft": 65535,
      "Hard": 65535
    }
},
```
