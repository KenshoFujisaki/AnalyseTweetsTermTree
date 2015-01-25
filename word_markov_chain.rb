#!/usr/local/bin/ruby
# encode: UTF-8

# マルコフ連鎖の格納ハッシュ
# markov_hash{"word" => {"word1" => count}}
markov_hash = {}

# 特徴語分かち書きファイル読み込み
preline = ""
File.foreach("./_tmp_wakati", :encoding => Encoding::UTF_8) do |line|

	# 文末の\nを除去
	line.chomp!

	# prelineをスキップ
	if preline==""
		preline = line
		next
	end
	
	# preline->lineをmarkov_hashに追加
	if markov_hash.has_key?(preline)
		if markov_hash[preline].has_key?(line)
			markov_hash[preline][line] += 1
		else
			markov_hash[preline][line] = 1
		end
	else
		markov_hash[preline] = {line => 1}
	end

	# 現在行をprelineに待避
	preline = line
end

# マルコフ連鎖を標準出力
puts "digraph twitter_markov_chain {"
markov_hash.each do |from_word, to_hash|
	to_hash.keys.each do |to_word|
		puts "  \"" + from_word + "\" -> \"" + to_word + "\";" if to_word != ""
	end
end
puts "}"
