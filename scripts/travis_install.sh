#!/bin/sh
#
sudo apt-get install libzmq3-dev -y
sudo apt-get install $LUA -y
sudo apt-get install $LIBLUA -y
LUA_LIBDIR=`pkg-config $LUA --variable=libdir`
INSTALL_LMOD=`pkg-config $LUA --variable=INSTALL_LMOD`
INSTALL_CMOD=`pkg-config $LUA --variable=INSTALL_CMOD`
## make sure there is a 'lua' command.
if [ ! -x /usr/bin/lua ]; then
  sudo ln -s `which $LUA` /usr/bin/lua;
fi
## install lua-llthreads
git clone git://github.com/Neopallium/lua-llthreads.git
cd lua-llthreads ; mkdir build ; cd build
cmake .. -DLUA_LIBRARIES=$LUA_LIBDIR -DLUA_INCLUDE_DIR=$LUA_INCDIR
  -DINSTALL_LMOD=$INSTALL_LMOD -DINSTALL_CMOD=$INSTALL_CMOD
make
sudo make install
cd ../..


