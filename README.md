# AnalyseTweetsTermTree

指定期間中におけるツイートについて，下図のような語彙のマルコフ連鎖を可視化します．  
これにより，発言の傾向を確認することができます．  
![](http://f.st-hatena.com/images/fotolife/n/ni66ling/20150126/20150126033247.png)  
[オリジナル画像はこちら](http://f.st-hatena.com/images/fotolife/n/ni66ling/20150126/20150126033402_original.png)

## 事前準備
1. TweetデータのMySQL格納  
    [KenshoFujisaki/CreateTwitterLogDB](https://github.com/KenshoFujisaki/CreateTwitterLogDB)に従いデータ準備を行う．

2. pythonパッケージのインストール  
    ```sh
    $ sudo pip install nltk
    $ python
    >>> import nltk
    >>> nltk.download()
    >>> quit()
    $ sudo pip install matplotlib
    ```

3. 形態素解析器(MeCab)のインストール  
    ```sh
    $ brew install mecab
    ```
    <!-- 
    Jumanの場合  
    [日本語形態素解析システムJUMAN](http://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN)にしたがってインストール  
    -->

4. graphvizのインストール  
    ```sh
    $ brew install graphviz
    ```

## 使い方
1. グラフの出力
    ```sh
    $ ./create_graph.sh [from_date] [to_date] [is_remove_tmp_files]
    ```
    + [from_date]と[to_date]には，それぞれ解析対象の開始日と終了日を指定します．
      例えば，[from_date]に「2014-12-01」を，[to_date]に「2014-12-31」を指定すると，2014-12-01から2014-12-31までの期間を対象に処理します．
    + [is_remove_tmp_files]は一時ファイルを自動的に削除するかのフラグ．trueで削除する，falseで削除しない．
    + 例えば，`$ ./create_graph.sh 2014-12-01 2014-12-31 true`のように実行します．
