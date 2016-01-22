#### build using pre-generated bindings.
mkdir build; cd build
cmake .. -DLUA_LIBRARIES=$LUA_LIBDIR -DLUA_INCLUDE_DIR=$LUA_INCDIR
  -DINSTALL_LMOD=$INSTALL_LMOD -DINSTALL_CMOD=$INSTALL_CMOD
make
sudo make install
# Run tests.
$LUA ../tests/test_inproc.lua
$LUA ../perf/thread_lat.lua 1 1000
cd .. ; rm -rf build
#### Re-Generate bindings.
git clone git://github.com/Neopallium/LuaNativeObjects.git;
mkdir build; cd build
cmake .. -DLUA_LIBRARIES=$LUA_LIBDIR -DLUA_INCLUDE_DIR=$LUA_INCDIR
  -DLUA_NATIVE_OBJECTS_PATH=$TRAVIS_BUILD_DIR/LuaNativeObjects
  -DUSE_PRE_GENERATED_BINDINGS=OFF -DGENERATE_LUADOCS=OFF
  -DINSTALL_LMOD=$INSTALL_LMOD -DINSTALL_CMOD=$INSTALL_CMOD
make
sudo make install
# Run tests.
$LUA ../tests/test_inproc.lua
$LUA ../perf/thread_lat.lua 1 1000

