#!/bin/sh

# 引数理解
if [ $# -ne 3 ]; then
	echo "usage:   $0 [from_date] [to_date] [is_remove_tmp_files]"
	echo "example: $0 2014-12-01 2014-12-31 true"
	exit 1
fi

# wakati書き呼び出し
./mysql_query_then_morpho_mecab.sh $1 $2 wakati > ./_tmp_wakati

# graphvizのDSL書き出し
ruby ./word_markov_chain.rb > ./_tmp_graphviz

# graphviz呼び出し
dot -Tpng _tmp_graphviz -o twitter_morpho_chain_$1_$2.png

# 中間ファイルを削除
if [ $3 = "true" ]; then
	rm -f _tmp_wakati
	rm -f _tmp_graphviz
fi

# 書き出しファイルを開く
open twitter_morpho_chain_$1_$2.png
