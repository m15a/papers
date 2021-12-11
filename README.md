# papers

主に機械学習関連（となるはず？）の論文読みのメモです。

## 使い方（備忘録）

### インストール

```sh
nix profile install github:m15a/papers
```

上記でコマンドライン補完が追加され[パッチ][2]が当てられた[pubs][1]と，
BibTeXファイルから`abstract`フィールドだけ削除するための補助スクリプト`muzzle-bibfile`が
環境にインストールされる。

このディレクトリを`pubs`のディレクトリとして使うため，cloneする。

```sh
git clone https://github.com/m15a/papers /path/to/papers
```

### `pubs`の設定

`~/.pubsrc`で，cloneしたこのディレクトリを`pubsdir`に設定する。
`bibtex_field_excludes`で`abstract`を除外するように指定する。
また，gitプラグインを有効にしておく。

```
[main]

# Where the pubs repository files (bibtex, metadata, notes) are located
pubsdir = /path/to/papers

...

# which bibliographic fields to exclude from bibtex files.
bibtex_field_excludes = abstract

...

[plugins]
# Comma-separated list of the plugins to load.
# Currently pubs comes with built-in plugins alias and git.
active = alias, git
```

[1]: https://github.com/pubs/pubs
[2]: https://github.com/pubs/pubs/pull/273
