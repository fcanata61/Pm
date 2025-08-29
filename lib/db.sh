#!/usr/bin/env bash
db_file(){ echo "${PM_DB}/installed.db"; }
db_lock(){ echo "${PM_DB}/.lock"; }

db_init(){
  mkdir -p "${PM_DB}"
  [[ -f "$(db_file)" ]] || : >"$(db_file)"
}

db_add(){
  local name="$1" version="$2" files="$3" deps="$4"
  grep -vE "^${name}\|" "$(db_file)" > "$(db_file).tmp" 2>/dev/null || true
  mv "$(db_file).tmp" "$(db_file)"
  echo "${name}|${version}|${files}|${deps}" >>"$(db_file)"
}

db_remove(){
  local name="$1"
  grep -vE "^${name}\|" "$(db_file)" > "$(db_file).tmp" || true
  mv "$(db_file).tmp" "$(db_file)"
}

db_query(){
  local name="$1"
  grep -E "^${name}\|" "$(db_file)" || true
}

db_list(){ cat "$(db_file)"; }

db_installed_version(){
  local name="$1"
  db_query "$name" | awk -F'|' '{print $2}' | head -n1
}
