#!/bin/bash




echo "启动调试容器....."





docker run -d --net=host -v $(pwd):/root/dev  -e $@ liuwenru/centos_dev 
