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

function git {
  if [[ "$1" == "branch" && "$@" != *"--help"* ]]; then
    shift 1
    command git br "$@"
  else
    command git "$@"
  fi
}

function emoji {
  chars=()
  for arg in $@; do
    arg=$(echo $arg | tr '[:upper:]' '[:lower:]')
    for (( i=0; i<${#arg}; i++ )); do
      chars+=("${arg:$i:1}")
    done
    chars+=("_")
  done

  str=""
  for char in ${chars[@]}; do
    case $char in
    @) str+='\U1f171\Ufe0f\U2005';; # 🅱️ 
    a) str+='\U1f1e6\U2005';; # 🇦
    b) str+='\U1f1e7\U2005';; # 🇧
    c) str+='\U1f1e8\U2005';; # 🇨
    d) str+='\U1f1e9\U2005';; # 🇩
    e) str+='\U1f1ea\U2005';; # 🇪
    f) str+='\U1f1eb\U2005';; # 🇫
    g) str+='\U1f1ec\U2005';; # 🇬
    h) str+='\U1f1ed\U2005';; # 🇭
    i) str+='\U1f1ee\U2005';; # 🇮
    j) str+='\U1f1ef\U2005';; # 🇯
    k) str+='\U1f1f0\U2005';; # 🇰
    l) str+='\U1f1f1\U2005';; # 🇱
    m) str+='\U1f1f2\U2005';; # 🇲
    n) str+='\U1f1f3\U2005';; # 🇳
    o) str+='\U1f1f4\U2005';; # 🇴
    p) str+='\U1f1f5\U2005';; # 🇵
    q) str+='\U1f1f6\U2005';; # 🇶
    r) str+='\U1f1f7\U2005';; # 🇷
    s) str+='\U1f1f8\U2005';; # 🇸
    t) str+='\U1f1f9\U2005';; # 🇹
    u) str+='\U1f1fa\U2005';; # 🇺
    v) str+='\U1f1fb\U2005';; # 🇻
    w) str+='\U1f1fc\U2005';; # 🇼
    x) str+='\U1f1fd\U2005';; # 🇽
    y) str+='\U1f1fe\U2005';; # 🇾
    z) str+='\U1f1ff\U2005';; # 🇿
    _) str+='\U2003\U2003';;
    0) str+='\U30\Ufe0f\U20e3\U2005';; # 0️⃣
    1) str+='\U31\Ufe0f\U20e3\U2005';; # 1️⃣
    2) str+='\U32\Ufe0f\U20e3\U2005';; # 2️⃣
    3) str+='\U33\Ufe0f\U20e3\U2005';; # 3️⃣
    4) str+='\U34\Ufe0f\U20e3\U2005';; # 4️⃣
    5) str+='\U35\Ufe0f\U20e3\U2005';; # 5️⃣
    6) str+='\U36\Ufe0f\U20e3\U2005';; # 6️⃣
    7) str+='\U37\Ufe0f\U20e3\U2005';; # 7️⃣
    8) str+='\U38\Ufe0f\U20e3\U2005';; # 8️⃣
    9) str+='\U39\Ufe0f\U20e3\U2005';; # 9️⃣
    *)
      echo "ERROR"
      return 1
      ;;
    esac
  done
  echo -en "$str" | tee >(xclip)
  echo
}

alias vi=vim
export EDITOR=`which vim`

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
