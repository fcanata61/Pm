#!/usr/bin/env bash
search_pkg() {
  local q="$1"
  grep -ril "$q" "${PM_RECIPE_DIR}"/*/recipe.sh 2>/dev/null | sed -E "s|.*/([^/]+)/recipe.sh|\1|"
}

info_pkg() {
  local pkg="$1"
  local f="${PM_RECIPE_DIR}/${pkg}/recipe.sh"
  [[ -f "$f" ]] || die "Receita não encontrada: $pkg"
  # shellcheck disable=SC1090
  source "$f"
  echo -e "${BLD}${CYN}$pkg${RST}"
  echo "  Versão: ${VERSION}"
  echo "  Fonte: ${SOURCE}"
  echo "  Dependências: ${DEPS:-nenhuma}"
  [[ -n "$PATCHES" ]] && echo "  Patches: ${PATCHES}"
}
