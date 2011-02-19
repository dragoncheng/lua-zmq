#
# Lua bindings for 0MQ
#
cmake_minimum_required(VERSION 2.8)

project(lua-zmq C)

set(BUILD_SHARED_LIBS TRUE)

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set(INSTALL_CMOD share/lua/cmod CACHE PATH "Directory to install Lua binary modules (configure lua via LUA_CPATH)")
set(LUA_NATIVE_OBJECTS_PATH ../LuaNativeObjects CACHE PATH
				"Directory to LuaNativeObjects bindings generator.")
set(USE_PRE_GENERATED_BINDINGS TRUE CACHE BOOL
				"Set this to FALSE to re-generate bindings using LuaNativeObjects")

set(COMMON_CFLAGS "${CFLAGS}")
set(COMMON_LDFLAGS)
set(COMMON_LIBS)

## Lua 5.1.x
include(FindLua51)
if(NOT ${LUA51_FOUND})
    message(FATAL_ERROR "The FindLua51 module could not find lua :-(")
endif()
set(COMMON_LIBS "${COMMON_LIBS};${LUA_LIBRARIES}")

## LibZMQ
include(FindPkgConfig)
pkg_search_module(ZMQ REQUIRED libzmq)
set(COMMON_CFLAGS "${COMMON_CFLAGS} ${ZMQ_CFLAGS}")
set(COMMON_LDFLAGS "${COMMON_LDFLAGS} ${ZMQ_LDFLAGS}")
set(COMMON_LIBS "${COMMON_LIBS};${ZMQ_LIBRARIES}")

## LuaNativeObjects
include(LuaNativeObjects)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
                    ${CMAKE_CURRENT_BINARY_DIR}
                    ${LUA_INCLUDE_DIR})

## LuaZMQ
set(LUA_ZMQ_SRC
	zmq.nobj.lua
)

if(${USE_PRE_GENERATED_BINDINGS})
	set(LUA_ZMQ_SRC pre_generated-zmq.nobj.c)
else()
	# Generate Lua bindings.
	GenLuaNativeObjects(LUA_ZMQ_SRC)
endif()

add_library(lua-zmq MODULE ${LUA_ZMQ_SRC})
target_link_libraries(lua-zmq ${COMMON_LIBS})
set_target_properties(lua-zmq PROPERTIES PREFIX "")
set_target_properties(lua-zmq PROPERTIES COMPILE_FLAGS "${COMMON_CFLAGS}")
set_target_properties(lua-zmq PROPERTIES OUTPUT_NAME zmq)

install(TARGETS lua-zmq
        DESTINATION "${INSTALL_CMOD}")
