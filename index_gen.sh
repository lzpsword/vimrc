#!/bin/bash
# =========================================================
# Script: gen_index.sh
# Purpose: Generate/update cscope and ctags indexes with timing
# =========================================================

set -e

# -------------------------
# 工具检查
# -------------------------
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: '$1' is not installed."
    if [ "$1" = "ctags" ]; then
      echo "Install: sudo apt install -y exuberant-ctags or universal-ctags"
    elif [ "$1" = "cscope" ]; then
      echo "Install: sudo apt install -y cscope"
    fi
    exit 1
  fi
}

check_command ctags
check_command cscope

# -------------------------
# 帮助
# -------------------------
show_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  -c      Only generate cscope"
  echo "  -t      Only generate ctags"
  echo "  -a      Generate both"
  echo "  -h      Show help"
}

# -------------------------
# 参数处理
# -------------------------
DO_CSCOPE=0
DO_CTAG=0

if [ $# -eq 0 ]; then
  show_help
  exit 0
fi

while getopts "ctah" opt; do
  case $opt in
    c) DO_CSCOPE=1 ;;
    t) DO_CTAG=1 ;;
    a) DO_CSCOPE=1; DO_CTAG=1 ;;
    h) show_help; exit 0 ;;
    *) show_help; exit 1 ;;
  esac
done

# -------------------------
# 总耗时开始
# -------------------------
TOTAL_START=$(date +%s)

# -------------------------
# 生成文件列表
# -------------------------
echo "==> Building source file list..."
LIST_START=$(date +%s)

CSCOPE_FILE_LIST="cscope.files"

find . \
  -path "./out" -prune -o \
  -path "./.git" -prune -o \
  -name "*.c" -o -name "*.cpp" -o -name "*.h" -o \
  -name "*.java" -o -name "*.aidl" \
  -print > "$CSCOPE_FILE_LIST"

LIST_END=$(date +%s)
LIST_COST=$((LIST_END - LIST_START))

echo "Source files: $(wc -l < "$CSCOPE_FILE_LIST")"
echo "File scan time: ${LIST_COST}s"

# -------------------------
# cscope
# -------------------------
if [ "$DO_CSCOPE" -eq 1 ]; then
  echo "==> Generating cscope index..."
  CSCOPE_START=$(date +%s)

  if [ -f cscope.out ]; then
    cscope -u -q -k
  else
    cscope -b -q -k
  fi

  CSCOPE_END=$(date +%s)
  CSCOPE_COST=$((CSCOPE_END - CSCOPE_START))

  echo "cscope done in ${CSCOPE_COST}s"
fi

# -------------------------
# ctags
# -------------------------
if [ "$DO_CTAG" -eq 1 ]; then
  echo "==> Generating ctags index..."
  CTAGS_START=$(date +%s)

  if [ -f tags ]; then
    ctags -R \
      --languages=C,C++,Java \
      --exclude=out \
      --exclude=.git \
      --extra=+q \
      --append=yes
  else
    ctags -R \
      --languages=C,C++,Java \
      --exclude=out \
      --exclude=.git \
      --extra=+q
  fi

  CTAGS_END=$(date +%s)
  CTAGS_COST=$((CTAGS_END - CTAGS_START))

  echo "ctags done in ${CTAGS_COST}s"
fi

# -------------------------
# 总耗时
# -------------------------
TOTAL_END=$(date +%s)
TOTAL_COST=$((TOTAL_END - TOTAL_START))

echo "----------------------------------------"
echo "Total time: ${TOTAL_COST}s"
echo "----------------------------------------"

# -------------------------
# Vim 提示
# -------------------------
echo "Vim commands:"
[ "$DO_CSCOPE" -eq 1 ] && echo "  :cs add $(pwd)/cscope.out"
[ "$DO_CTAG" -eq 1 ] && echo "  :set tags=$(pwd)/tags;,tags;"

