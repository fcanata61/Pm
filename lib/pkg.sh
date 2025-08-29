#!/usr/bin/env bash
# lib/pkg.sh - gerenciamento de instalação/remoção de pacotes

# Instalar pacote (a partir de build)
install_pkg() {
  local pkg="$1"
  local work="${PM_BUILD}/$pkg"
  local dest="${PM_DESTDIR}/$pkg"
  local src="$work/src/${NAME}-${VERSION}"

  mkdir -p "$dest"

  # Instala no DESTDIR (com lista de arquivos)
  phase_install "$pkg" "$src" "$dest"

  # Copiar para o sistema real (usando fakeroot para simular root)
  info "Aplicando no sistema com fakeroot"
  run_with_spinner "fakeroot cp -a $dest/* /" || die "Falha ao aplicar arquivos no sistema"

  # Registrar no banco de dados
  db_add "$pkg" "$VERSION" "${PM_DB}/${pkg}.files" "$DEPS"
  ok "Pacote $pkg instalado"
}

# Instalar binário empacotado (.tar.zst)
install_binary() {
  local tarfile="$1"
  local pkg
  pkg=$(basename "$tarfile" .tar.zst)

  info "Instalando binário $pkg"
  run_with_spinner "fakeroot tar --zstd -xvf $tarfile -C /" || die "Falha ao extrair binário"

  db_add "$pkg" "binary" "${PM_DB}/${pkg}.files" ""
  ok "Pacote binário $pkg instalado"
}

# Remover pacote (com base na lista de arquivos)
remove_pkg() {
  local pkg="$1"
  local entry
  entry="$(db_query "$pkg")" || die "Pacote não encontrado: $pkg"

  local files
  files=$(echo "$entry" | cut -d'|' -f3)

  info "Removendo arquivos de $pkg"
  if [[ -f "$files" ]]; then
    while read -r f; do
      # remove no sistema
      run_with_spinner "fakeroot rm -rf /$f" || warn "Falha ao remover $f"
    done <"$files"
    rm -f "$files"
  else
    warn "Lista de arquivos não encontrada para $pkg"
  fi

  db_remove "$pkg"
  ok "Pacote $pkg removido"
}
