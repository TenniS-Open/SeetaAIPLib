#!/usr/bin/env bash

export FAKE_TENNIS="ON"

HOME=$(cd `dirname $0`; pwd)
PROJECT="$HOME/../.."

cmake "$PROJECT" \
"$@" \
-DCMAKE_BUILD_TYPE=Release \
-DAIP_FAKE_TENNIS="${FAKE_TENNIS}"

