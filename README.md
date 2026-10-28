# MyMacProfile

日常开发环境使用的 shell profile 和工具配置。主要支持 Linux、Apple Silicon macOS、Bash 和 Zsh；Windows 提供 Git Bash 范围的基础支持。Git Bash 创建软链接可能需要启用 Windows Developer Mode，并配置 MSYS 的 symlink 支持。

## 目录

| 目录 | 用途 |
| --- | --- |
| `profile/` | Bash、Zsh、平台配置、常用 alias 和函数 |
| `git/` | Git 全局配置和 ignore 规则 |
| `maven/`、`gradle/` | Java 构建工具配置 |
| `neovim/`、`tmux/`、`vscode/` | 编辑器和终端工具配置 |
| `docker/` | Docker daemon 配置示例 |
| `linux_dev/`、`mac_dev/`、`win_dev/` | 平台专用配置或历史产物 |
| `opencode/` | OpenCode 全局约定 |

## 安装

安装脚本不会默认执行任何目标。建议先预览：

```bash
./install.sh --dry-run all
```

再按需安装：

```bash
./install.sh profile git maven
```

Neovim 可以通过顶层安装器或目录内的快捷脚本单独安装：

```bash
./install.sh neovim
# 或
./neovim/install.sh
```

安装器会把 `~/.config/nvim` 链接到仓库中的 `neovim/`；已有配置会先按时间戳备份。

如果目标文件已经存在，脚本会先创建带时间戳的备份，再建立软链接。Profile 安装完成后，在 `~/.bashrc` 和 `~/.zshrc` 中按需加入：

```bash
source "${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile/profile/profile.sh"
```

原来直接加载 `profile/devprofile.sh` 的配置仍然可用，该文件现在是兼容入口。

各工具目录中的 `install.sh` 会转发到顶层安装器，因此不再依赖执行时的当前目录。VS Code 配置备份使用独立命令：

```bash
./vscode/export.sh
```

## Profile 加载顺序

```text
profile/profile.sh
  -> profile/common.sh
  -> profile/bash.sh 或 profile/zsh.sh
  -> profile/platform/linux.sh、macos.sh 或 windows.sh
  -> profile/bashfunc.sh
  -> ~/.config/mymacprofile/local.sh
```

`local.sh` 用于凭据、机器路径和不应提交的个人设置。可参考 `profile/local.example.sh`：

```bash
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile"
cp profile/local.example.sh "${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile/local.sh"
chmod 600 "${XDG_CONFIG_HOME:-$HOME/.config}/mymacprofile/local.sh"
```

目前内网主机 alias 和固定工作路径为保持兼容，仍保留在 `profile/common.sh` 与平台文件中，后续再决定是否迁入本机配置。

## Maven 凭据

`maven/settings.xml` 不再保存明文凭据，而是读取以下环境变量：

```text
EPOINT_NEXUS_USERNAME
EPOINT_NEXUS_PASSWORD
CLOUD_MAVEN_USERNAME
CLOUD_MAVEN_PASSWORD
```

可在私有 `local.sh` 中设置这些变量。历史版本曾包含明文凭据，因此相关密码仍需立即轮换；当前整理不重写 Git 历史。

## 当前兼容策略

以下兼容行为已经确认继续保留：

- `curl`、`wget` 跳过证书校验
- autoenv 自动信任 `.env`
- Maven 默认跳过测试并放宽 TLS 校验
- Gradle 放宽 TLS 校验并允许旧 TLS 协议
- VS Code 关闭代理证书和扩展签名验证
- Git 使用 `credential.helper=store` 明文保存凭据
- 全局 `CFLAGS`、`CXXFLAGS` 使用 `-g -O0`
- 内网地址、工作主机 alias 和固定工具目录

这些配置适用于当前受控工作环境，但不应直接复制到不可信网络或共享机器。

## 常用依赖

```bash
# macOS
brew install ripgrep ctags gnupg
brew install --cask keycastr hiddenbar

# Fedora/RHEL 系 Linux
dnf install ripgrep fuse-sshfs

# Go
go install github.com/jstemmer/gotags@latest
go install mvdan.cc/sh/v3/cmd/gosh@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Python
pip3 install autopep8 sqlparse nginxfmt
```
