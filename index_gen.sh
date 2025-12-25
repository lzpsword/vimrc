#!/bin/bash
# =========================================================
# Script: gen_index.sh
# Purpose: Incrementally generate/update cscope and ctags indexes for large projects
# Author: Neil (example)
# Usage: ./gen_index.sh [-c] [-t] [-a] [-h]
# Options:
#   -c    Only generate/update cscope
#   -t    Only generate/update ctags
#   -a    Generate/update both (default)
#   -h    Show this help message
# =========================================================

set -e

# -------------------------
# 先检查工具是否安装
# -------------------------
function check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: '$1' is not installed. Please install it first."
    if [ "$1" == "ctags" ]; then
      echo "For Ubuntu/Debian: sudo apt install -y exuberant-ctags or universal-ctags"
    elif [ "$1" == "cscope" ]; then
      echo "For Ubuntu/Debian: sudo apt install -y cscope"
    fi
    exit 1
  fi
}

# 检查 ctags 和 cscope
check_command ctags
check_command cscope

# -------------------------
# 默认标志
# -------------------------
DO_CSCOPE=0
DO_CTAG=0

# -------------------------
# 显示帮助
# -------------------------
function show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  -c      Only generate/update cscope"
  echo "  -t      Only generate/update ctags"
  echo "  -a      Generate/update both (default if no option)"
  echo "  -h      Show this help message"
  echo ""
  echo "Example usage:"
  echo "  $0 -a       # generate both"
  echo "  $0 -c       # only cscope"
  echo "  $0 -t       # only ctags"
}

# -------------------------
# 解析参数
# -------------------------
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

while getopts "ctaHh" opt; do
  case $opt in
    c) DO_CSCOPE=1 ;;
    t) DO_CTAG=1 ;;
    a) DO_CSCOPE=1; DO_CTAG=1 ;;
    h|H) show_help; exit 0 ;;
    *) show_help; exit 1 ;;
  esac
done

# -------------------------
# 文件列表
# -------------------------
CSCOPE_FILE_LIST="cscope.files"
echo "==> Building file list..."

find . \
  -path "./out" -prune -o -path "./.git" -prune -o \
  -name "*.c" -o -name "*.cpp" -o -name "*.h" -o \
  -name "*.java" -o -name "*.aidl" \
  -print > $CSCOPE_FILE_LIST

echo "Total source files: $(wc -l < $CSCOPE_FILE_LIST)"

# -------------------------
# 生成/更新 cscope
# -------------------------
if [ "$DO_CSCOPE" -eq 1 ]; then
  echo "==> Generating/updating cscope index..."
  if [ -f "cscope.out" ]; then
    cscope -u -q -k
  else
    cscope -b -q -k
  fi
  echo "cscope index ready: cscope.out"
fi

# -------------------------
# 生成/更新 ctags
# -------------------------
if [ "$DO_CTAG" -eq 1 ]; then
  echo "==> Generating/updating ctags index..."
  if [ -f "tags" ]; then
    CTAGS_CMD="ctags -R --languages=C,C++,Java --exclude=out --exclude=.git --extra=+q --append=yes"
  else
    CTAGS_CMD="ctags -R --languages=C,C++,Java --exclude=out --exclude=.git --extra=+q"
  fi
  eval $CTAGS_CMD
  echo "tags file ready"
fi

# -------------------------
# Vim load instructions
# -------------------------
if [ "$DO_CSCOPE" -eq 1 ] || [ "$DO_CTAG" -eq 1 ]; then
  VIM_COSCOPE_LOAD="cs add $(pwd)/cscope.out"
  VIM_TAGS_PATH="set tags=$(pwd)/tags;,tags;"
  echo "==> Vim load instructions:"
  echo "Add the following to your vimrc or run inside Vim:"
  echo "  $VIM_COSCOPE_LOAD"
  echo "  $VIM_TAGS_PATH"
fi

echo "==> Done."

