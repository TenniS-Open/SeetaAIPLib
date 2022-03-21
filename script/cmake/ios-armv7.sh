#!/usr/bin/env bash

# ARCH: armv7 armv7s arm64 i386 x86_64

export TARGET=9 
export ENABLE_BITCODE=0
export PLATFORM=OS

export ARCH="armv7;armv7s"
export TAG=master

export FAKE_TENNIS="ON"

HOME=$(cd `dirname $0`; pwd)
PROJECT="$HOME/../.."

# git checkout $TAG
cmake "$PROJECT" \
"$@" \
-DCMAKE_TOOLCHAIN_FILE="$PROJECT/toolchain/iOS.cmake" \
-DCMAKE_BUILD_TYPE=Release \
-DAIP_FAKE_TENNIS="${FAKE_TENNIS}" \
-DIOS_DEPLOYMENT_TARGET=$TARGET \
-DIOS_PLATFORM=$PLATFORM \
-DENABLE_BITCODE=$ENABLE_BITCODE \
-DIOS_ARCH="$ARCH"

