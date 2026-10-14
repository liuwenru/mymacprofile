# CLAUDE.md

本文档用于指导 Claude Code 在本仓库中工作。开始修改前，应先阅读根目录 `README.md`、目标目录内的 `README.md`，并重新读取将要修改的配置文件；文档中标记为 `Reference Documentation` 的资料应作为重点约束。

## 仓库定位

这是一个个人开发环境和 dotfiles 仓库，用于维护 Linux、Apple Silicon macOS 以及部分 Windows Git Bash 环境中的 Shell、编辑器、终端和构建工具配置。它不是单一应用工程，没有统一的编译或测试入口；修改通常会直接影响用户全局配置，因此兼容性和可回滚性优先于大规模重构。

主要支持：

- Bash 和 Zsh
- Linux 与 Apple Silicon macOS
- Windows Git Bash 基础环境
- 通过软链接部署到用户主目录的配置文件

## 目录结构

| 路径 | 用途 |
| --- | --- |
| `install.sh` | 顶层统一安装器，负责备份和创建软链接 |
| `profile/` | Shell 公共配置、Bash/Zsh 配置、平台配置、alias 和函数 |
| `git/` | Git 全局配置和全局 ignore 规则 |
| `maven/`、`gradle/` | Java 构建工具配置 |
| `vim/` | 基于 vim-plug 的传统 Vim 配置，继续保留兼容 |
| `neovim/` | 基于 LazyVim 的 Neovim 配置 |
| `tmux/` | 基于旧版 Oh My Tmux 快照的稳定配置 |
| `vscode/` | VS Code 设置、快捷键和配置导出脚本 |
| `terminal/` | macOS Terminal 主题及 Zsh 工具参考资料 |
| `docker/` | Docker daemon 配置示例 |
| `completions/` | Docker、kubectl 等 Zsh 补全脚本 |
| `linux_dev/` | Linux 离线开发产物、FUSE/SSHFS 文件及辅助脚本 |
| `mac_dev/`、`win_dev/` | macOS、Windows 专用配置和历史资料 |
| `opencode/` | OpenCode 全局规则与配置 |
| `systemd-unit-files-example/` | systemd mount/service 示例 |
| `tampermonkey/` | Tampermonkey 脚本及备份 |

## 安装机制

顶层 `install.sh` 是主要安装入口，支持以下目标：

```text
profile git maven gradle vim neovim tmux vscode opencode all
```

安装前应优先使用 dry-run：

```bash
./install.sh --dry-run all
./install.sh --dry-run profile git
```

确认输出后再按需实际安装：

```bash
./install.sh profile git
```

安装器在目标已存在时会创建带时间戳的备份，然后建立指向仓库文件的软链接。各工具目录中的 `install.sh` 通常只负责定位自身路径并转发到顶层安装器，不要重复实现安装逻辑。

当前已知不一致：顶层安装器和旧 tmux 插件脚本会引用 `tmux/tmux.conf.local`，但该文件目前不在仓库中。涉及 tmux 安装时不要假设该文件存在，也不要在未确认预期内容的情况下自动创建它。

## Profile 架构

推荐入口为 `profile/profile.sh`，实际加载顺序是：

```text
profile/profile.sh
  -> profile/common.sh
  -> profile/bash.sh 或 profile/zsh.sh
  -> profile/platform/linux.sh、macos.sh 或 windows.sh
  -> profile/bashfunc.sh
  -> ~/.config/mymacprofile/local.sh
```

- `profile/devprofile.sh` 是旧配置的兼容入口，只转发到 `profile/profile.sh`。
- Shell 共享设置放入 `profile/common.sh`，Shell 专属设置放入 `bash.sh` 或 `zsh.sh`。
- 操作系统专属路径、alias 和环境变量放入 `profile/platform/` 对应文件。
- 凭据、机器私有路径及不应提交的设置放入 `~/.config/mymacprofile/local.sh`，模板见 `profile/local.example.sh`。
- `profile/local.sh` 和 `*.local` 已被 `.gitignore` 忽略，不要把本机私密配置移回受版本控制的文件。

## 关键配置说明

- `profile/default.conf` 是 Shadowrocket 分流配置，不是 Shell profile。修改前应查看文件头部链接的 Shadowrocket 配置手册，注意规则自上而下匹配，`FINAL` 必须作为兜底项。
- `maven/settings.xml` 通过 `EPOINT_NEXUS_USERNAME`、`EPOINT_NEXUS_PASSWORD`、`CLOUD_MAVEN_USERNAME`、`CLOUD_MAVEN_PASSWORD` 读取凭据，不得写回明文密码。
- `neovim/` 来自 LazyVim starter，修改前参考 `neovim/README.md` 和 LazyVim 官方文档。
- `vim/` 与 `neovim/` 是并行配置；不要以迁移为由直接删除旧 Vim 配置。
- `tmux/tmux.conf` 目前作为稳定的旧配置保留，现代化迁移应单独进行，不要顺手改变现有快捷键和插件行为。
- `linux_dev/fuse3-aarch64/` 和 `linux_dev/fuse3-x86_64/` 包含离线二进制、静态库和高权限 mount helper。来源信息尚不完整，不要随意覆盖或视为可验证发布制品。

## 已确认保留的兼容行为

以下设置存在安全或可移植性风险，但属于当前工作环境中明确保留的行为。除非用户专门要求，不要自行“修复”或移除：

- `curl`、`wget` 跳过证书校验
- zsh-autoenv 自动信任 `.env`
- Maven 默认跳过测试并放宽 TLS 校验
- Gradle 放宽 TLS 校验并允许旧 TLS 协议
- VS Code 关闭代理证书和扩展签名验证
- Git 使用 `credential.helper=store`
- 全局 `CFLAGS`、`CXXFLAGS` 使用 `-g -O0`
- 内网地址、工作主机 alias 和固定工具目录

这些配置只适合当前受控工作环境，不应直接复制到不可信网络或共享机器。

## 修改原则

1. 保持现有目录职责和脚本风格，Shell 脚本使用 Bash，避免过度封装。
2. 编写代码或配置时优先使用相对路径；脚本内部需要稳定定位时沿用 `BASH_SOURCE[0]` 和 `pwd -P` 的模式。
3. 不要覆盖、删除或还原来源不明的用户改动，尤其是个人配置和历史产物。
4. 不执行 Git commit 或 push，由用户人工完成。
5. Docker 构建只能使用默认 buildx，不要创建或修改额外的 buildx builder。
6. 外部资源访问失败时可按 `opencode/AGENTS.md` 中的代理方式重试；下载内容在使用前应验证来源和完整性。
7. 执行会修改系统、用户主目录或外部环境的命令前，使用已确认的绝对工作路径，并先告知用户执行内容及影响。

## 格式和验证

仓库没有统一测试套件。应根据改动范围执行最小且有针对性的验证：

- 安装器：先运行对应目标的 `./install.sh --dry-run ...`，检查备份路径和软链接目标。
- Bash 脚本：使用 `bash -n` 做语法检查；环境具备 ShellCheck 时再执行静态检查。
- Profile：分别关注 Bash、Zsh 语法以及 Linux、macOS、Git Bash 平台分支，不要在当前 Shell 中直接加载未经检查的完整配置。
- JSON/JSONC、XML、Gradle、Lua 配置：使用对应解析器或工具检查，避免用不兼容的严格 JSON 工具校验 JSONC。
- Neovim：安装后可按照 LazyVim 官方建议执行 `:LazyHealth`。
- Linux 离线产物：在支持 `sha256sum` 的环境中使用 `sha256sum -c linux_dev/fuse3-SHA256SUMS` 验证关键文件。

根目录 `.editorconfig` 规定使用 UTF-8、LF 和两个空格缩进。修改已有文件时还应尊重该文件原有格式，避免无关的全文件格式化。
