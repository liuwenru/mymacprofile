#!/bin/bash

rm /usr/local/bin/cleandocker

ln -s $(pwd)/cleandocker.sh /usr/local/bin/cleandocker

chmod +x /usr/local/bin/cleandocker

rm /usr/local/bin/rundebugdocker
ln -s $(pwd)/rundebugdocker.sh /usr/local/bin/rundebugdocker
chmod +x /usr/local/bin/rundebugdocker






