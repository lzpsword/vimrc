# vim常用操作

分屏跳转：
ctrl+w h/j/k/l  “ctrl+w后要松开再输入后面的方向

## 快捷键
space+n     NERDTree文件浏览打开/关闭

## NERDTree操作
i   打开文件（上下分屏）
s   左右分屏（左右分屏）

## EasyMotion
space space w   输入字符

## cscope & ctags 函数跳转
### 环境安装

`sudo apt install -y cscope exuberant-ctags or sudo apt install -y universal-ctags
`ctags --version
`cscope -V

### 生成索引

调用index_gen.sh

### 使用

手动设置ctags和cscope文件
`:cs add /home/neil/aosp/cscope.out
`:set tags=/home/neil/aosp/tags;,tags;


| 操作  | 命令               | 场景       |
| --- | ---------------- | -------- |
| 查定义 | `:cs find g foo` | 函数在哪定义   |
| 查调用 | `:cs find c foo` | 谁调用了 foo |
| 查引用 | `:cs find s foo` | foo 被谁用  |
| 查文本 | `:cs find t foo` | 文本搜索     |

| 操作   | 快捷键      |
| ---- | -------- |
| 跳转定义 | `Ctrl-]` |
| 返回   | `Ctrl-t` |

