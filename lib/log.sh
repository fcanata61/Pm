#!/usr/bin/env bash
log_ts() { date +"%Y-%m-%d %H:%M:%S"; }
_log() { local lvl="$1"; shift; echo -e "[$(log_ts)] ${lvl} $*${RST}" | tee -a "${PM_LOG}"; }
info(){ _log "${BLU}INFO${RST}:" "$@"; }
ok(){ _log "${GRN} OK ${RST}:" "$@"; }
warn(){ _log "${YLW}WARN${RST}:" "$@"; }
err(){ _log "${RED}ERR ${RST}:" "$@" >&2; }
die(){ err "$@"; exit 1; }
debug(){ [[ "${PM_VERBOSE}" == "1" ]] && _log "${DIM}DBG ${RST}:" "$@"; }
