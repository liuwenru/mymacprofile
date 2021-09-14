# MyMacProfile

个人笔记本的一些配置，主要包含 iterm2，vim，secureCRT 等，在`Linux`和`MAC`上都可以通用

## Mac (intel 芯片)

### homebrew 需要安装的插件

```bash
brew install reattach-to-user-namespace
brew install ripgrep
brew install --cask mounty # 在MAC上支持挂载NTFS磁盘
brew install --cask keycastr # 自动影藏显示按键的工具，录制屏幕时有用
brew install --cask hiddenbar   # 自动影藏显示mac状态栏的工具
brew install gnupg
brew install autoenv #自动刷新env的小工具
brew install ctags
brew install ripgrep
```

## Windows

`windows office 设置默认字体优先级`

```bash
Shell> sudo defaults write com.microsoft.office PrioritizedFonts -array "SourceHanSerifSC-Regular" "SourceCodePro-Regular" "STHeitiSC-Light"

```

## Linux 必装软件

```bash
dnf install fuse-sshfs
dnf install ripgrep
```

## 通用的 golang 实现的工具

```bash
go install github.com/jstemmer/gotags@latest
go install mvdan.cc/sh/v3/cmd/gosh@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

## 通用的 python 实现的工具

```bash
pip3 install autopep8
pip3 install sqlparse
pip3 install nginxfmt
```

## 为 git 添加自动补全

参考文档

https://github.com/git/git/tree/master/contrib/completion

```bash
# 针对zsh可以使用
Shell> curl -k -o /usr/local/share/zsh/site-functions/git-completion.zsh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
# 针对bash可以使用
Shell> https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
```

## 最精简的 zsh 插件

- https://github.com/sindresorhus/pure
- https://github.com/zsh-users/zsh-autosuggestions
- https://github.com/zsh-users/zsh-syntax-highlighting
- https://github.com/Tarrasch/zsh-autoenv
- https://github.com/zsh-users/zsh-completions 
## debug zsh 的响应时间

有的时候我们会发现按回车zsh耗时会很长，可以使用下面的方法进行调试
```bash
Shell> PS4='%D{%s.%9.}+%N:%i> ' zsh -xv 

```
