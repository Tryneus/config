#!/usr/bin/env bash

source "$(dirname "$0")/utils.bash"

set -x

# $1 - file
# $2 - line
ensure_exists_and_contains () {
  if [[ ! -e "$1" ]]; then
    echo "$2" > "$1"
  else
    found="$(true && grep "^$2$" "$1")"
    if [[ -z "$found" ]]; then
      echo "$2" >> "$1"
    fi
  fi
}

make_symlink () {
  mkdir -p "$(dirname "$1")"
  if [[ -e "$1" ]]; then
    rm -rf "$1"
  fi
  ln -sf "$2" "$1"
}

# $1 - link
# $2 - target
maybe_symlink () {
  mkdir -p "$(dirname "$1")"
  if [[ ! -e "$1" ]]; then
    make_symlink "$1" "$2"
  fi
}

# Symlinks all contents of the target directory into the source directory
symlink_contents () {
  for f in $2/*; do
    if [[ -e "$f" ]]; then
      if [[ ! -d "$f" ]]; then
        echo "linking $1/$(basename $f) -> $f"
        make_symlink "$1/$(basename $f)" "$f"
      fi
    fi
  done

  return 0
}

# Directory of this repo
CONFIG="$(dirname "$(realpath "$0")")"

# Make sure ~/install/bin exists for future steps
BIN="$(readlink -fm "$HOME/install/bin")"
mkdir -p "$BIN"

install_base () {
  # If ~/.bashrc doesn't exist, make it
  source_config="source \"$CONFIG/.bashrc\""
  ensure_exists_and_contains "$HOME/.bashrc" "$source_config"

  # If ~/.bash_profile doesn't exist, make it and source bashrc
  source_bashrc="source ~/.bashrc"
  ensure_exists_and_contains "$HOME/.bash_profile" "$source_bashrc"

  # If ~/.bash_completion.d doesn't exist, make it
  if [[ ! -e "$HOME/.bash_completion.d" ]]; then
    mkdir "$HOME/.bash_completion.d"
  fi

  make_symlink "$HOME/.ackrc" "$CONFIG/.ackrc"
  make_symlink "$HOME/.alacritty.yml" "$CONFIG/.alacritty.yml"
}

build_ncurses() {
  # TODO: check if this has already been configured/built
  pushd "$CONFIG/ncurses"
  ./configure --prefix="$CONFIG/ncurses" && make
  make_res=$?
  popd

  if [[ "$make_res" != 0 ]]; then
    echo "ncurses build failed"
    return 1
  fi
}

install_vim () {
  # TODO: check installed version vs checked-in version, uninstall and reinstall if stale, alternatively have a '--force' option
  # Check if vim is already installed with clipboard support
  #if which vim > /dev/null; then
  #  if [[ -n "$(vim --version | grep +clipboard)" ]]; then
  #    return 0
  #  fi
  #fi
  build_ncurses

  # TODO: needed libx11-dev, libxt-dev, and tinfo-dev installed
  ncurses_lib="$CONFIG/ncurses/lib/"
  #configure_flags="--with-x --with-features=normal --prefix=$CONFIG/vim --with-tlib=tinfo"
  configure_flags="--with-features=normal --prefix=$CONFIG/vim --enable-multibyte --with-tlib=ncurses --enable-gui=no"

  pushd "$CONFIG/vim"
  ./configure $configure_flags && pushd src && make install && popd
  make_res=$?
  popd

  if [[ "$make_res" != 0 ]]; then
    echo "vim build failed"
    return 1
  fi

  echo source: $BIN
  echo target: $CONFIG/vim/bin
  symlink_contents $BIN $CONFIG/vim/bin
}

configure_vim() {
  # Symlink vimrc - overwrite any existing one
  make_symlink "$HOME/.vimrc" "$CONFIG/.vimrc"
  return 0
}

install_vim_modules() {
  # Symlink vim resources to this repo if missing
  make_symlink "$HOME/.vim/colors/custom.vim" "$CONFIG/.vim/colors/custom.vim"
  make_symlink "$HOME/.vim/autoload/pathogen.vim" "$CONFIG/vim-pathogen/autoload/pathogen.vim"
  make_symlink "$HOME/.vim/bundle/vim-airline" "$CONFIG/vim-airline"
  make_symlink "$HOME/.vim/bundle/vim-airline-themes" "$CONFIG/vim-airline-themes"
  make_symlink "$HOME/.vim/bundle/vim-fugitive" "$CONFIG/vim-fugitive"
  make_symlink "$HOME/.vim/bundle/vim-jsx" "$CONFIG/vim-jsx-improve"
  make_symlink "$HOME/.vim/bundle/vim-toml" "$CONFIG/vim-toml"
  make_symlink "$HOME/.vim/bundle/typescript-vim" "$CONFIG/typescript-vim"
  make_symlink "$HOME/.vim/bundle/tagbar" "$CONFIG/tagbar"
  
  return 0
}

install_gitconfig() {
  gitconfig="$CONFIG/.gitconfig"
  if [[ -z "$(git config --global --get-all include.path | grep "^$gitconfig$")" ]]; then
    git config --global --add include.path "$gitconfig"
  fi
}

install_clang () {
  if which clang++ > /dev/null; then
    return 0
  fi

}

install_gcc () {
  if which g++ > /dev/null; then
    return 0
  fi

}

install_nvm () {
  # This loads nvm
  \. "$CONFIG/.nvm/nvm.sh"

  # Our bashrc already points to the submodule, just install a node version
  nvm install --lts
  nvm install-latest-npm
  return 0
}

install_node () {
  return 0
}

install_rbenv () {
  if which rbenv > /dev/null; then
    return 0
  fi

  git submodule init rbenv
  make_symlink "$HOME/.rbenv" "$CONFIG/rbenv"
  # TODO: make sure there aren't more things added at runtime
  symlink_contents "$BIN" "$CONFIG/rbenv/bin"
}

install_gvm () {
  if which gvm > /dev/null; then
    return 0
  fi

  GVM_NO_UPDATE_PROFILE=true bash "$CONFIG/gvm/binscripts/gvm-installer"
}

install_go () {
  source ~/.gvm/scripts/gvm

  # Later versions of go require a go compiler to build, install v1.4 from binary
  gvm install go1.4 -B
  gvm use go1.4
  export GOROOT_BOOTSTRAP=$GOROOT
  gvm install go1.13.3
  gvm use go1.13.3 --default
}

install_gotags () {
  if which gotags > /dev/null; then
    return 0
  fi

  go get -u github.com/jstemmer/gotags
}

install_pyenv () {
  if which pyenv > /dev/null; then
    return 0
  fi

  git submodule init pyenv
  make_symlink "$HOME/.pyenv" "$CONFIG/pyenv"
  # TODO: this probably won't work because the python link isn't there yet
  symlink_contents "$BIN" "$CONFIG/pyenv/bin"
}

install_ipython () {
  if which ipython > /dev/null; then
    return 0
  fi
}

configure_ipython() {
  make_symlink "$HOME/.ipython" "$CONFIG/.ipython"
  return 0
}

install_rustup () {
  if which rustup > /dev/null; then
    return 0
  fi

  curl https://sh.rustup.rs -sSf | sh -s -- -y
}

default_install=(base vim git)
all=(${default_install[@]} c++ node ruby go python rust)

for name in $@; do
  case "$name" in
  all)
    to_install+=$all
    ;;
  *)
    to_install+=("$name")
    ;;
  esac
done

if [[ -z "$to_install" ]]; then
  to_install=${default_install[@]}
fi

to_install=($(for v in "${to_install[@]}"; do echo "$v"; done | sort | uniq | xargs))

echo "Initializing submodules"
git submodule init

echo "Updating submodules"
git submodule update

echo "to install: ${to_install[@]}"

for name in "${to_install[@]}"; do
  case "$name" in
  base)
    echo "installing base configuration"
    install_base
    ;;
  vim)
    echo "installing vim"
    install_vim
    configure_vim
    install_vim_modules
    ;;
  vim-config)
    echo "configuring vim"
    configure_vim
    install_vim_modules
    ;;
  git)
    echo "installing git"
    install_gitconfig
    ;;
  c++)
    echo "installing c++"
    install_clang
    install_gcc
    ;;
  node)
    echo "installing node"
    install_nvm
    install_node
    ;;
  ruby)
    echo "installing ruby"
    install_rbenv
    ;;
  go)
    echo "installing go"
    install_gvm
    install_go
    install_gotags
    ;;
  python)
    echo "installing python"
    install_pyenv
    install_ipython
    configure_ipython
    ;;
  rust)
    echo "installing rust"
    install_rustup
    ;;
  *)
    echo "Unrecognized environment: $name"
  esac
done

# TODO: make it easy to set up ssh key with github
# maybe generate a key and print it for copy/paste?
# open in a browser: https://github.com/settings/keys
