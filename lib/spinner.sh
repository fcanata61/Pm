#!/usr/bin/env bash
run_with_spinner() {
  local cmd="$*"
  if [[ "${PM_SPINNER}" != "1" ]] || [[ ! -t 1 ]]; then
    bash -c "${cmd}"
    return $?
  fi
  local pid
  bash -c "${cmd}" & pid=$!
  local frames='|/-\' i=0
  while kill -0 $pid 2>/dev/null; do
    printf "\r${CYN}[%c]${RST} %s" "${frames:i++%4:1}" "${cmd:0:60}..."
    sleep 0.1
  done
  wait $pid
  local rc=$?
  printf "\r"
  return $rc
}
