#!/bin/bash

if [[ ! -f ~/.m2/settings.xml ]]; then
  ln -s $(pwd)/settings.xml ~/.m2/settings.xml
  ln -s $(pwd)/jvm.config ~/.m2/jvm.config
fi
