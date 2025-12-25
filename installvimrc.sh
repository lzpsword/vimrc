#!/bin/bash
set -e

DOTFILES_DIR=$PWD
VIMCONFIG_DIR="vim"
VIM_DIR="$HOME/.vim"
VIMRC="$HOME/.vimrc"

echo "==> Installing vim configuration..."


# 备份旧配置
if [ -f "$VIMRC" ]; then
  echo "Backing up existing .vimrc to .vimrc.bak"
  mv "$VIMRC" "$VIMRC.bak"
fi

# 建立软链接
ln -sf "$DOTFILES_DIR/$VIMCONFIG_DIR/vimrc" "$VIMRC"
ln -sf "$DOTFILES_DIR/$VIMCONFIG_DIR" "$VIM_DIR"

# 创建目录
mkdir -p "$VIM_DIR/undo"

# 安装 vim-plug
if [ ! -f "$VIM_DIR/autoload/plug.vim" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$VIM_DIR/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "==> Done."
echo "Open vim and run :PlugInstall or just set cmd: vim +PlugInstall +qall"

