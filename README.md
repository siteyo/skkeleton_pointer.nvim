# skkeleton_pointer.nvim

Skkeletonのモードと入力段階の状態をポップアップで表示します。

入力段階の状態表示は、変換開始位置に固定で表示されます。

## 依存プラグイン

- [vim-denops/denops.vim](https://github.com/vim-denops/denops.vim)
- [vim-skk/skkeleton](https://github.com/vim-skk/skkeleton)

## インストール

```lua
-- lazy.nvim
{
  "siteyo/skkeleton_pointer.nvim",
  dependencies = {
    "vim-skk/skkeleton",
  }
  config = true,
}
```
