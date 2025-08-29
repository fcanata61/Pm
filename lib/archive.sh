#!/usr/bin/env bash
detect_arch_type() {
  local f="$1"
  case "$f" in
    *.tar.gz|*.tgz) echo "tar.gz" ;;
    *.tar.bz2|*.tbz2) echo "tar.bz2" ;;
    *.tar.xz|*.txz) echo "tar.xz" ;;
    *.tar.zst|*.tzst) echo "tar.zst" ;;
    *.zip) echo "zip" ;;
    *.gz) echo "gz" ;;
    *.bz2) echo "bz2" ;;
    *.xz) echo "xz" ;;
    *.zst) echo "zst" ;;
    *) echo "dir" ;;
  esac
}

unpack_to() {
  local src="$1" out="$2"
  mkdir -p "$out"
  local t="$(detect_arch_type "$src")"
  info "Descompactando ${src} -> ${out} (tipo: ${t})"
  case "$t" in
    tar.gz)  tar -xzf "$src" -C "$out" ;;
    tar.bz2) tar -xjf "$src" -C "$out" ;;
    tar.xz)  tar -xJf "$src" -C "$out" ;;
    tar.zst) tar --zstd -xf "$src" -C "$out" ;;
    zip)     unzip -q "$src" -d "$out" ;;
    gz)      gunzip -c "$src" > "${out}/$(basename "${src%.gz}")" ;;
    bz2)     bunzip2 -c "$src" > "${out}/$(basename "${src%.bz2}")" ;;
    xz)      unxz -c "$src" > "${out}/$(basename "${src%.xz}")" ;;
    zst)     unzstd -c "$src" > "${out}/$(basename "${src%.zst}")" ;;
    dir)     cp -a "$src" "$out/" ;;
  esac
}
