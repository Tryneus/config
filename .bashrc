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
    @) str+='\U1f171\Ufe0f\U2000';; # 🅱️ 
    a) str+='\U1f1e6\U2000';; # 🇦
    b) str+='\U1f1e7\U2000';; # 🇧
    c) str+='\U1f1e8\U2000';; # 🇨
    d) str+='\U1f1e9\U2000';; # 🇩
    e) str+='\U1f1ea\U2000';; # 🇪
    f) str+='\U1f1eb\U2000';; # 🇫
    g) str+='\U1f1ec\U2000';; # 🇬
    h) str+='\U1f1ed\U2000';; # 🇭
    i) str+='\U1f1ee\U2000';; # 🇮
    j) str+='\U1f1ef\U2000';; # 🇯
    k) str+='\U1f1f0\U2000';; # 🇰
    l) str+='\U1f1f1\U2000';; # 🇱
    m) str+='\U1f1f2\U2000';; # 🇲
    n) str+='\U1f1f3\U2000';; # 🇳
    o) str+='\U1f1f4\U2000';; # 🇴
    p) str+='\U1f1f5\U2000';; # 🇵
    q) str+='\U1f1f6\U2000';; # 🇶
    r) str+='\U1f1f7\U2000';; # 🇷
    s) str+='\U1f1f8\U2000';; # 🇸
    t) str+='\U1f1f9\U2000';; # 🇹
    u) str+='\U1f1fa\U2000';; # 🇺
    v) str+='\U1f1fb\U2000';; # 🇻
    w) str+='\U1f1fc\U2000';; # 🇼
    x) str+='\U1f1fd\U2000';; # 🇽
    y) str+='\U1f1fe\U2000';; # 🇾
    z) str+='\U1f1ff\U2000';; # 🇿
    _) str+='\U2003\U2000';;
    0) str+='\U30\Ufe0f\U20e3\U2000';; # 0️⃣
    1) str+='\U31\Ufe0f\U20e3\U2000';; # 1️⃣
    2) str+='\U32\Ufe0f\U20e3\U2000';; # 2️⃣
    3) str+='\U33\Ufe0f\U20e3\U2000';; # 3️⃣
    4) str+='\U34\Ufe0f\U20e3\U2000';; # 4️⃣
    5) str+='\U35\Ufe0f\U20e3\U2000';; # 5️⃣
    6) str+='\U36\Ufe0f\U20e3\U2000';; # 6️⃣
    7) str+='\U37\Ufe0f\U20e3\U2000';; # 7️⃣
    8) str+='\U38\Ufe0f\U20e3\U2000';; # 8️⃣
    9) str+='\U39\Ufe0f\U20e3\U2000';; # 9️⃣
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
