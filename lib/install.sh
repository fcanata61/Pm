#!/usr/bin/env bash
install_binary(){
  local pkg="$1"
  local file
  file=$(ls -1t "${PM_PKG}/${pkg}-"*.tar.* 2>/dev/null | head -n1 || true)
  [[ -z "$file" ]] && die "Pacote binário não encontrado: $pkg"
  info "Instalando pacote binário: $file"
  mkdir -p "${PM_BUILD}/$pkg/bininstall"
  (cd "${PM_BUILD}/$pkg/bininstall" && tar -xf "$file")
  fakeroot cp -a "${PM_BUILD}/$pkg/bininstall"/* /
  db_add "$pkg" "$(recipe_version "$pkg")" "/" "$(recipe_deps "$pkg")"
}

remove_pkg(){
  local pkg="$1"
  local line; line="$(db_query "$pkg")"
  [[ -z "$line" ]] && { warn "Pacote $pkg não instalado"; return; }
  local files; files="$(echo "$line" | cut -d'|' -f3)"
  info "Removendo $pkg"
  # não temos lista real de arquivos, apenas destdir → remove manualmente não suportado ainda
  db_remove "$pkg"
}
