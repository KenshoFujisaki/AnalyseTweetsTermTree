#!/bin/bash

# 引数理解
if [ $# -ne 3 ]; then
	echo example:
	echo $0 2013-10-01 2013-10-14 normal
	echo $0 2013-10-01 2013-10-14 wakati
	echo $0 2013-10-01 2013-10-14 original
	exit 1
fi

# $1から$2までのtweetについて，特徴語を抽出
# 特徴語の選択方法
# ・名詞（ただし，一般名詞，固有名詞のみ．
# 　　　　数名詞，接尾名詞，特殊名詞，代名詞，非自立名詞，サ変接続名詞，
# 　　　　副詞可能名詞，形容動詞語幹名詞，ナイ形容詞語幹名詞は除去）
# ・はてなキーワードによる辞書において，変なのは除去
# ・笑とーは特別に除去
# ・漢字以外からなる単語については，１文字以下は除去
# また，後の処理のために英字は総て小文字化する
if [ $3 = "normal" ]; then
	mysql -utwitter -ptwitter -Dtwitter -e "select tweet from tweetlog where time >= '$1' and time <= '$2'" \
		| ruby -ne 'print $_.gsub(/(http:\/\/|https:\/\/|@)[0-9a-zA-Z\.\/_]+|RT/, "")' \
		| mecab -E "\n" \
		| ruby -ne 'sep=$_.split(" "); print sep[0].to_s + " " + sep[1].to_s.split(",").join(" ") + "\n"' \
		| awk '$2=="名詞"||$2==""{print $0}' | awk '$3=="一般"||$3=="固有名詞"||$3==""{if ($1!="笑" && $1!="ー") print $0 }' \
		| awk '$1!~/^[0-9]+$/{print $0}' \
		| grep -vE '^[あ-んぁ-ぉゃ-ょa-zA-Zア-ンァ-ォャ-ョ]{1}[^あ-んぁ-ぉゃ-ょa-zA-Zア-ンァ-ォャ-ョ]' \
		| ruby -ne 'puts $_.downcase'
elif [ $3 = "wakati" ]; then
	mysql -utwitter -ptwitter -Dtwitter -e "select tweet from tweetlog where time >= '$1' and time <= '$2'" \
		| ruby -ne 'print $_.gsub(/(http:\/\/|https:\/\/|@)[0-9a-zA-Z\.\/_]+|RT/, "")' \
		| mecab -E "\n" \
		| ruby -ne 'sep=$_.split(" "); print sep[0].to_s + " " + sep[1].to_s.split(",").join(" ") + "\n"' \
		| awk '$2=="名詞"||$2==""{print $0}' | awk '$3=="一般"||$3=="固有名詞"||$3==""{if ($1!="笑" && $1!="ー" && $1!="_") print $0 }' \
		| awk '$1!~/^[0-9]+$/{print $0}' \
		| grep -vE '^[あ-んぁ-ぉゃ-ょa-zA-Zア-ンァ-ォャ-ョ]{1}[^あ-んぁ-ぉゃ-ょa-zA-Zア-ンァ-ォャ-ョ]' \
		| ruby -ne 'puts $_.downcase' \
		| awk '{print $1}'
elif [ $3 = "original" ]; then
	mysql -utwitter -ptwitter -Dtwitter -e "select tweet from tweetlog where time >= '$1' and time <= '$2'" \
		| ruby -ne 'print $_.gsub(/(http:\/\/|https:\/\/|@)[0-9a-zA-Z\.\/_]+|RT/, "")' \
		| mecab -E "\n"	
else
	echo 'please let $3 normal or wakati'
	$0
fi
