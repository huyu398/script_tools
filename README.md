# script_tools

いい加減に研究等で使うスクリプトをまとめる．

## tex_table_generator.rb
Excel で表を作ってから，それを論文やゼミ資料のために LaTeX に再整形するの面倒くさい．
あと， duplicate されるから，ファイル間の同期を取るのも大変．
これらを解決するために自動でやる．

#### USAGE
csv ファイル内のデータを表と捉えて， LaTeX で組版できるように出力する．

```sh
ruby tex_table_generator.rb
```
実行後に tex ファイル内に以下を記載．
```tex
\input{./table_output.tex}
```

#### IMPLEMENTATION
入力ファイルと表のキャプションはソース内で設定する．
出力ファイル名は `table_output.tex` ，出力先はソースファイルと同一ディレクトリ．
キャプションを設定した場合， `'tab:' + キャプション` でラベルを付与する．
キャプションを設定しない場合は， caption および label のコマンドは出力ファイルにはない．
表は n*m になるように空白セルで埋め，表の罫線は全セルに付与する．

#### TODO
- [ ] コマンドライン引数で入力情報を管理する
  - [ ] 入力ファイルをコマンドライン引数で指定する
  - [ ] キャプションをオプションで指定する
    - [ ] キャプションの入力にいい媒体は他にない？
  - [ ] 罫線の付与パターンをオプションで指定する
    - [ ] 天地線のみ `\Hline` とか，左右端の罫線のみなしとか，その組み合わせ
  - [ ] LaTeX のソースファイル分割には `docmute` パッケージがいいらしいので，それに対応するオプションを作る (http://d.hatena.ne.jp/zrbabbler/20150906/1441509908)
- [ ] Excel で作成したファイルを入力とした時を確かめる
  - [ ] Excel で作成した csv ファイルの形式ってどうなってるの？
  - [ ] そもそも xlsx ファイルに対応する
    - [ ] 罫線の指定は xlsx ファイルの各セルの書式指定で決める
    - [ ] セルの結合に対応する
      - [ ] 横方向のみは `\muticolumn` でいい
      - [ ] 縦方向はややこしい
      - [ ] 組み合わさるともっとややこしい
    - [ ] セル内のデータが数式で決まっていた場合はどうなるのか確かめる
    - [ ] 表のセル内に画像を入れる
      - [ ] Excel のセル内に画像を入れることは可能か？
        - [ ] 可能なら，その情報は取得できるのか？
        - [ ] 不可能なら，セル内に専用のシーケンスを書けば展開するようにする
- [ ] いろいろ盛り込んで，規模が大きくなったら module 構造にリファクタリングする
  - [ ] というか gem にする
