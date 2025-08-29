#!/usr/bin/env bash
# Configurações gerais do gerenciador "sourcer"

: "${PM_NAME:=sourcer}"
: "${PM_PREFIX:=${HOME}/.local}"
: "${PM_ROOT:=${HOME}/.local/share/${PM_NAME}}"
: "${PM_WORKDIR:=${PM_ROOT}/work}"
: "${PM_CACHE:=${PM_ROOT}/cache}"
: "${PM_DB:=${PM_ROOT}/db}"
: "${PM_LOGDIR:=${PM_ROOT}/logs}"
: "${PM_RECIPE_DIR:=${PM_ROOT}/recipes}"
: "${PM_HOOKS_DIR:=${PM_ROOT}/hooks}"
: "${PM_JOBS:=1}"
: "${PM_FAKEROOT:=}"      # ex.: fakeroot
: "${PM_STRIP:=0}"
: "${PM_CURL_OPTS:=-L --fail --retry 3}"
: "${PM_WGET_OPTS:=--tries=3 --quiet --show-progress}"
: "${PM_FETCH_TIMEOUT:=0}"
: "${PM_COLOR:=1}"
: "${PM_SPINNER:=1}"
: "${PM_VERBOSE:=0}"
: "${PM_FORCE:=0}"
: "${PM_PACKAGE_FMT:=tar.gz}"
: "${PM_DESTDIR:=${PM_ROOT}/destdir}"

mkdir -p "${PM_WORKDIR}" "${PM_CACHE}" "${PM_DB}" "${PM_LOGDIR}" \
         "${PM_RECIPE_DIR}" "${PM_HOOKS_DIR}/pre-install.d" "${PM_HOOKS_DIR}/post-remove.d"
