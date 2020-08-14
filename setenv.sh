#!/bin/bash
export LOCAL_UID=$(id -u $USER)
export LOCAL_GID=$(id -g $USER)
export LOCAL_DISPLAY=${DISPLAY:-0.0}
export XDG_RUNTIME_DIR=/run/user/$(id -u $USER)
export WORK_DIR=work
