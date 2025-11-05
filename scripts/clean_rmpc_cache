#!/usr/bin/env bash
# Exit immediately if a command exits with a non-zero status
set -o errexit
# Fail a pipeline if any command errors
set -o pipefail
# Treat unset variables as an error
set -o nounset

CACHE_DIR="/tmp/rmpc/cache/youtube"

if [[ -d "$CACHE_DIR" && "$(ls -A "$CACHE_DIR")" ]]; then
  rm -v -- "$CACHE_DIR"/*
  echo "Deleted all cached YouTube files."
else
  echo "Nothing is here Amit 😥"
fi
