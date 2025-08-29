#!/usr/bin/env bash
recipe_var(){
  local pkg="$1" var="$2"
  local f="${PM_RECIPE_DIR}/${pkg}/recipe.sh"
  [[ -f "$f" ]] || return 1
  # shellcheck disable=SC1090
  source "$f"
  eval "echo \"\${$var:-}\""
}

recipe_version(){ recipe_var "$1" VERSION; }
recipe_source(){ recipe_var "$1" SOURCE; }
recipe_patches(){ recipe_var "$1" PATCHES; }
recipe_build(){ recipe_var "$1" BUILD; }
recipe_deps(){ recipe_var "$1" DEPS; }

phase_fetch(){
  local pkg="$1"
  local src="$(recipe_source "$pkg")"
  [[ -z "$src" ]] && return 0
  mkdir -p "${PM_BUILD}/$pkg"
  case "$src" in
    git+*) fetch_source "$src" "${PM_BUILD}/$pkg/src" ;;
    http*|ftp*) local f="$(fetch_source "$src" "${PM_CACHE}")"; echo "$f" >"${PM_BUILD}/$pkg/source.list" ;;
  esac
}

phase_unpack(){
  local pkg="$1"
  mkdir -p "${PM_BUILD}/$pkg"
  if [[ -f "${PM_BUILD}/$pkg/source.list" ]]; then
    while read -r f; do
      unpack_to "$f" "${PM_BUILD}/$pkg/src"
    done <"${PM_BUILD}/$pkg/source.list"
  fi
}

phase_patch(){
  local pkg="$1"
  local patches="$(recipe_patches "$pkg")"
  [[ -z "$patches" ]] && return 0
  (cd "${PM_BUILD}/$pkg/src" && for p in $patches; do
    if [[ "$p" =~ ^http ]]; then
      local pf="${PM_CACHE}/$(basename "$p")"
      fetch_file "$p" "$pf"
      patch -p1 <"$pf"
    else
      patch -p1 <"${PM_RECIPE_DIR}/$pkg/$p"
    fi
  done)
}

phase_build(){
  local pkg="$1"
  local buildcmd="$(recipe_build "$pkg")"
  [[ -z "$buildcmd" ]] && buildcmd="./configure --prefix=/usr && make -j$(nproc)"
  (cd "${PM_BUILD}/$pkg/src" && eval "$buildcmd")
}

phase_install() {
  local pkg="$1"
  local src="$2"
  local dest="$3"

  info "Instalando $pkg em $dest"
  run_with_spinner "cd $src && $INSTALL" || die "Falha na instalação"

  # Salva lista de arquivos instalados
  local filelist="${PM_DB}/${pkg}.files"
  (cd "$dest" && find . -type f -o -type l -o -type d) > "$filelist"

  ok "Arquivos instalados registrados em $filelist"
}

make_package(){
  local pkg="$1"
  local dest="${PM_BUILD}/$pkg/dest"
  local out="${PM_PKG}/${pkg}-$(recipe_version "$pkg").tar.zst"
  mkdir -p "${PM_PKG}"
  (cd "$dest" && tar --zstd -cf "$out" .)
  echo "$out"
}
