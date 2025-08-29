#!/usr/bin/env bash
fetch_file() {
  local url="$1" out="$2"
  mkdir -p "$(dirname "$out")"
  if command -v curl >/dev/null 2>&1; then
    local t=(); [[ "${PM_FETCH_TIMEOUT}" != "0" ]] && t=(--max-time "${PM_FETCH_TIMEOUT}")
    curl ${PM_CURL_OPTS} "${t[@]}" -o "$out" "$url"
  elif command -v wget >/dev/null 2>&1; then
    local t=(); [[ "${PM_FETCH_TIMEOUT}" != "0" ]] && t=(--timeout="${PM_FETCH_TIMEOUT}")
    wget ${PM_WGET_OPTS} "${t[@]}" -O "$out" "$url"
  else
    die "Nem curl nem wget encontrados."
  fi
}

fetch_source() {
  local src="$1" destdir="$2"
  mkdir -p "${destdir}"
  case "$src" in
    git+*)  # git+https://...#commit=...,branch=...
      local url="${src#git+}"
      local ref=""
      [[ "$url" == *"#"* ]] && { ref="${url##*#}"; url="${url%%#*}"; }
      info "Clonando git: $url"
      if [[ -d "${destdir}/.git" ]]; then
        (cd "${destdir}" && git fetch --all && [[ -n "$ref" ]] && git checkout "${ref#*=}" || true)
      else
        git clone --depth 1 "$url" "${destdir}"
        [[ -n "$ref" ]] && (cd "${destdir}" && git checkout "${ref#*=}") || true
      fi
      ;;
    http://*|https://*|ftp://*)
      local fname="${src##*/}"
      info "Baixando: $src"
      fetch_file "$src" "${PM_CACHE}/${fname}"
      echo "${PM_CACHE}/${fname}"
      ;;
    *)
      cp -f "$src" "${destdir}/"
      echo "${destdir}/$(basename "$src")"
      ;;
  esac
}
