#!/bin/bash

if [[ ! -f ~/.gitconfig ]]; then
  echo "configure git config"
  ln -s $(pwd)/gitconfig ~/.gitconfig
  ln -s $(pwd)/gitignore_global ~/.gitignore_global
fi
