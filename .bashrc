pathadd() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

CONFIG="$(dirname "$(readlink -f "$BASH_SOURCE")")"
BIN="$(readlink -f ~/install/bin)"
pathadd "$BIN"
pathadd "$CONFIG/rbenv/bin"
pathadd "$CONFIG/pyenv/bin"

# TODO: set up ack ignore filetypes
function search() {
  ack "$*"
}

function searchci() {
  ack -i "$*"
}

function files() {
  ack -l "$*"
}

function filesci() {
  ack -li "$*"
}

alias vi=vim

if which pyenv > /dev/null; then
  export PYENV_ROOT="$CONFIG/pyenv"
  eval "$(pyenv init -)"
fi

gvm_init="$HOME/.gvm/scripts/gvm"
if [[ -s "$gvm_init" ]]; then
  source "$gvm_init"
fi
