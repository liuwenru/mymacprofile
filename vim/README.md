# Vim 配置

当前 Vim、YouCompleteMe 和 vim-go 配置继续保留。安装前预览：

```bash
../install.sh --dry-run vim
```

插件管理器使用 [vim-plug](https://github.com/junegunn/vim-plug)。

## Neovim 迁移计划

Neovim 配置将作为独立目录建设，不直接改写当前 `vimrc`：

1. 先迁移基础编辑习惯、搜索、文件导航和快捷键。
2. 使用内置 LSP，Go 使用 gopls，C/C++ 使用 clangd。
3. 使用 Treesitter 和独立 formatter，替代 YCM、gocode 等重叠职责。
4. Linux 和 Apple Silicon macOS 验证完成后，再决定是否删除旧插件。
