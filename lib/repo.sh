#!/usr/bin/env bash
repo_sync() {
  local repo="${PM_REPO_GIT}"
  [[ -z "$repo" ]] && die "PM_REPO_GIT não configurado."
  if [[ -d "${PM_RECIPE_DIR}/.git" ]]; then
    (cd "${PM_RECIPE_DIR}" && git pull)
  else
    git clone "$repo" "${PM_RECIPE_DIR}"
  fi
}
