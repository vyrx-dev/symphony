#!/bin/bash

pkill -x $1
setsid $1 >/dev/null 2>&1 &
