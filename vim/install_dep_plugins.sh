#!/bin/bash

# 安装 vim 中依赖的一些插件
envname=$(uname)
case ${envname} in
Linux)
  dnf install clang
  dnf install tidy
  dnf install ripgrep
  dnf install the_silver_searcher ack ripgrep
  ;;
Darwin)
  brew install clang-format
  brew install tidy-html5
  brew install ripgrep
  brew install the_silver_searcher ack ripgrep pt
  ;;
*) ;;
esac

# Linux和Mac平台都支持的版本
go install github.com/jstemmer/gotags@latest
go install mvdan.cc/sh/v3/cmd/gosh@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest

pip3 install autopep8
pip3 install sqlparse

npm install -g js-beautify standard eslint xo stylelint stylelint-config-standard typescript-formatter purty remark-cli fixjson
