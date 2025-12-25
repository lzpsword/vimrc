call plug#begin('~/.vim/plugged')

" 文件树
Plug 'preservim/nerdtree'

" 状态栏
Plug 'vim-airline/vim-airline'

" Git（看 diff、blame 非常有用）
Plug 'tpope/vim-fugitive'

" 快速跳转（读 AOSP 代码很好用）
Plug 'easymotion/vim-easymotion'

" C/C++ 补全（非 LSP，轻量）
Plug 'vim-scripts/c.vim'

call plug#end()

