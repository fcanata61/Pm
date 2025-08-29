#!/usr/bin/env bash
revdep_check() {
  local broken=()
  while IFS="|" read -r name version files deps; do
    for d in $deps; do
      if [[ -z "$(db_query "$d")" ]]; then
        warn "Pacote $name depende de $d, mas não está instalado."
        broken+=("$name")
      fi
    done
  done <"$(db_file)"
  [[ ${#broken[@]} -gt 0 ]] && echo "${broken[@]}"
}

revdep_rebuild() {
  local broken; broken=($(revdep_check))
  [[ ${#broken[@]} -eq 0 ]] && { ok "Nenhum pacote quebrado."; return; }
  info "Reconstruindo pacotes quebrados: ${broken[*]}"
  for pkg in "${broken[@]}"; do
    "${PM_ROOT}/sourcer.sh" build "$pkg"
    "${PM_ROOT}/sourcer.sh" install "$pkg"
  done
}
