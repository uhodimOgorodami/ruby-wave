# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

alphabet = ('a'..'z')
vowels = %w[a e i o u]
vowels_in_hash = {}

alphabet.each_with_index do |letter, index|
  vowels_in_hash[index + 1] = letter if vowels.include?(letter)
end
puts vowels_in_hash.to_s