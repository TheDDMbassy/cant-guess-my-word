DICTIONARY = File.readlines(
  Rails.root.join("db", "words_alpha.txt"),
  chomp: true
).to_set.freeze
puts "Dictionary file has been loaded"
