#!/usr/bin/env bash
set -e

# $1 - file
# $2 - line
ensure_exists_and_contains () {
  if [[ ! -e "$1" ]]; then
    echo "$2" > "$1"
  else
    found="$(grep "^$2$" "$1")"
    if [[ -z "$found" ]]; then
      echo "$2" >> "$1"
    fi
  fi
}

make_symlink () {
  ln -sf "$2" "$1"
}

# $1 - source
# $2 - target
maybe_symlink () {
  mkdir -p "$(dirname "$1")"
  if [[ ! -e "$1" ]]; then
    make_symlink "$1" "$2"
  fi
}

# Symlinks all contents of the target directory into the source directory
maybe_symlink_contents () {
  files=($(find . -maxdepth 1 -not -type d -printf "%f\n"))
  for f in $files; do
    maybe_symlink "$1/$f" "$2/$f"
  done
}

# Directory of this repo
CONFIG="$(dirname "$(readlink -f "$0")")"

# Make sure ~/install/bin exists for future steps
BIN="$(readlink -f ~/install/bin)"
mkdir -p "$BIN"

# If ~/.bashrc doesn't exist, make it
source_config="source \"$CONFIG/.bashrc\""
ensure_exists_and_contains ~/.bashrc "$source_config"

# If ~/.bash_profile doesn't exist, make it and source bashrc
source_bashrc="source ~/.bashrc"
ensure_exists_and_contains ~/.bash_profile "$source_bashrc"

install_vim () {
  # Check if vim is already installed with clipboard support
  if which vim > /dev/null; then
    if [[ -n "$(vim --version | grep +clipboard)" ]]; then
      return 0
    fi
  fi

  git submodule init vim

  # TODO: needed libncurses5 installed (and maybe passed to configure in --with-tlib)
  # TODO: needed libx11-dev and/or libxt-dev installed
  configure_flags="--with-x --with-features=normal --prefix=\"$CONFIG/vim\""

  pushd "$CONFIG/vim"
  ./configure "$configure_flags" && make install
  make_res=$?
  popd

  if [[ "$make_res" != 0 ]]; then
    echo "vim build failed"
    return 1
  fi
}

configure_vim() {
  # Symlink vimrc - overwrite any existing one
  make_symlink ~/.vimrc "$CONFIG/.vimrc"
}

install_vim_modules() {
  # Symlink vim resources to this repo if missing
  maybe_symlink ~/.vim/colors/custom.vim "$CONFIG/custom.vim"

  git submodule init pathogen
  maybe_symlink ~/.vim/autoload/pathogen.vim "$CONFIG/vim-pathogen/autoload/pathogen.vim"

  git submodule init vim-airline
  maybe_symlink ~/.vim/bundle/vim-airline "$CONFIG/vim-airline"

  git submodule init vim-airline-themes
  maybe_symlink ~/.vim/bundle/vim-airline-themes "$CONFIG/vim-airline-themes"

  git submodule init vim-fugitive
  maybe_symlink ~/.vim/bundle/vim-fugitive "$CONFIG/vim-fugitive"
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
  if which nvm > /dev/null; then
    return 0
  fi

}

install_rbenv () {
  if which rbenv > /dev/null; then
    return 0
  fi

  git submodule init rbenv
  maybe_symlink ~/.rbenv "$CONFIG/rbenv"
  # TODO: make sure there aren't more things added at runtime
  maybe_symlink "$BIN/ruby" "$CONFIG/rbenv/bin/ruby"
  maybe_symlink_contents "$BIN" "$CONFIG/rbenv/bin"
}

install_gvm () {
  if which gvm > /dev/null; then
    return 0
  fi

  GVM_NO_UPDATE_PROFILE=true bash "$CONFIG/gvm/binscripts/gvm-installer"
}

install_pyenv () {
  if which pyenv > /dev/null; then
    return 0
  fi

  git submodule init pyenv
  maybe_symlink ~/.pyenv "$CONFIG/pyenv"
  # TODO: this probably won't work because the python link isn't there yet
  maybe_symlink_contents "$BIN" "$CONFIG/pyenv/bin"
}

install_ipython () {
  if which ipython > /dev/null; then
    return 0
  fi
}

configure_ipython() {
  # TODO: set some default config options
}

install_rustup () {
  if which rustup > /dev/null; then
    return 0
  fi

  curl https://sh.rustup.rs -sSf | sh
}

# Always consider installing vim
to_install=(vim gitconfig)
all=(c++ node ruby go python rust)

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

to_install=($(for v in "${to_install[@]}"; do echo "$v"; done | sort | uniq | xargs))

for name in "${to_install[@]}"; do
  case "$name" in
  vim)
    install_vim()
    configure_vim()
    install_vim_modules()
    ;;
  gitconfig)
    install_gitconfig()
    ;;
  c++)
    install_clang()
    install_gcc()
    ;;
  node)
    install_nvm()
    ;;
  ruby)
    install_rbenv()
    ;;
  go)
    install_gvm()
    ;;
  python)
    install_pyenv()
    install_ipython()
    configure_ipython()
    ;;
  rust)
    install_rustup()
    ;;
  *)
    echo "Unrecognized environment: $name"
  esac
done

# TODO: make it easy to set up ssh key with github
# maybe generate a key and print it for copy/paste?
# open in a browser: https://github.com/settings/keys
