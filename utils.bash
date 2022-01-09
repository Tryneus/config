realpath () {
  if ! pushd "$(dirname "$1")" > /dev/null 2>&1; then
    return 1
  fi
  local link=$(readlink "$(basename "$1")")
  while [ "$link" ]; do
    popd > /dev/null 2>&1
    if !  pushd "$(dirname "$link")" > /dev/null 2>&1; then
      return 1
    fi
    link=$(readlink "$(basename "$1")")
  done
  echo "$PWD/$(basename "$1")"
  popd > /dev/null 2>&1
}
