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

# Node Version Manager settings, configured for nvm v0.34.0
export NVM_DIR="$CONFIG/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$HOME/.bash_completion" ] && \. "$HOME/.bash_completion"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

for f in "$HOME/.bash_completion.d/*" ; do
  [ -s "$f" ] && . "$f"
done

for f in "$CONFIG/.bash_completion.d/*" ; do
  [ -s "$f" ] && . "$f"
done
