#!/bin/bash



git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/tmux.conf.local ~/.tmux.conf.local
