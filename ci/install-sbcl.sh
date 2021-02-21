#!/bin/sh
set -e
curl -LJ0 https://github.com/roswell/sbcl_bin/releases/download/2.1.1/sbcl-2.1.1-x86-64-linux-binary.tar.bz2 > sbcl.tar.bz2
tar -xvf sbcl.tar.bz2
cd sbcl-2.1.1-x86-64-linux || exit 1
sudo sh install.sh
cd .. || exit 1
rm -rf sbcl-2.1.1-x86-64-linux
