#!/usr/bin/env bash
if [[ "${PM_COLOR}" != "1" ]] || [[ ! -t 1 ]]; then
  RED=""; GRN=""; YLW=""; BLU=""; MAG=""; CYN=""; BLD=""; DIM=""; RST=""
else
  RED=$'\e[31m'; GRN=$'\e[32m'; YLW=$'\e[33m'; BLU=$'\e[34m'; MAG=$'\e[35m'; CYN=$'\e[36m'
  BLD=$'\e[1m'; DIM=$'\e[2m'; RST=$'\e[0m'
fi
