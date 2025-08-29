#!/usr/bin/env bash
# Topological sort com dependências
# usa recursão + stack de marcação

declare -A __graph_seen
declare -a __graph_order

recipe_deps(){
  local pkg="$1"
  local f="${PM_RECIPE_DIR}/${pkg}/recipe.sh"
  [[ -f "$f" ]] || return 0
  # shellcheck disable=SC1090
  source "$f"
  echo "${DEPS:-}"
}

_topo_visit(){
  local node="$1"
  [[ "${__graph_seen[$node]}" == "perm" ]] && return
  [[ "${__graph_seen[$node]}" == "temp" ]] && die "Ciclo detectado em dependências: $node"
  __graph_seen[$node]="temp"
  local deps; deps=$(recipe_deps "$node")
  for d in $deps; do
    _topo_visit "$d"
  done
  __graph_seen[$node]="perm"
  __graph_order+=("$node")
}

topo_sort(){
  __graph_seen=(); __graph_order=()
  for n in "$@"; do _topo_visit "$n"; done
  printf "%s\n" "${__graph_order[@]}"
}

reverse_order(){
  tac || tail -r 2>/dev/null || awk '{a[NR]=$0}END{for(i=NR;i>0;i--)print a[i]}'
}
