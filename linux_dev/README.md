# Linux 离线开发产物

`fuse3-aarch64/` 和 `fuse3-x86_64/` 用于无法直接安装系统包的 Linux 机器。

## FUSE/SSHFS

- FUSE 版本：`3.16.2`，由两个目录中的 `fuse3.pc` 确认。
- 架构：`aarch64` 和 `x86_64`。
- 安装前缀：`/opt/fuse3`。
- 来源：本机从源码编译。
- 待补信息：精确源码 URL、Git commit/tag、SSHFS 版本、编译器版本和完整构建参数。

这些产物包含 mount helper 和静态库，可能进入高权限执行路径。在来源信息补齐前，不应将其视为可验证的发布制品，也不应部署到不可信机器。

关键可执行文件与库的 SHA-256 记录在 `fuse3-SHA256SUMS`。在仓库根目录验证：

```bash
sha256sum -c linux_dev/fuse3-SHA256SUMS
```
