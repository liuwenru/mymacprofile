#!/bin/bash

# 备份配置文件

envname=$(uname)
case ${envname} in
Linux)
    echo " linux install"
    ;;
Darwin)
    cp ~/Library/Application\ Support/Code/User/settings.json ./
    ;;
*) ;;
esac
