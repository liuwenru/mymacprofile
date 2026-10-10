# tmux 配置

当前配置基于 2021 年的 Oh My Tmux 快照，继续作为稳定配置使用。安装软链接：

```bash
../install.sh --dry-run tmux
../install.sh tmux
```

## 迁移计划

后续现代化配置单独实施，不直接修改当前快捷键：

1. 记录仍在使用的 prefix、分屏、resize、复制和会话恢复快捷键。
2. 新建精简配置，只保留 tmux-sensible、resurrect、continuum 等实际使用的插件。
3. 将 `default-terminal` 迁移到 `tmux-256color`，部署前检查本地和远端 terminfo。
4. 将一千万行 history 调整到可控范围，并观察长期会话内存。
5. 在 Linux 和 macOS 并行验证后，再替换旧 Oh My Tmux 主文件。

旧配置中的重复插件和选项暂不清理，避免在迁移前改变现有行为。
