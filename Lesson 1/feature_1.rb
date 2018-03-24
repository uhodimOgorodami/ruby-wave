# фича по выводу идеального веса

puts "Как Вас зовут?"
user_name = gets.chomp.capitalize

puts "#{user_name}, подскажите Ваш рост?"
user_height = gets.chomp

ideal_weight = user_height.to_i - 110

if ideal_weight < 0 # в условии задачи не говорится меньше, либо равно 0, поэтому использую только "<"
	puts "#{user_name}, Ваш вес уже оптимальный"
  else
	puts "#{user_name}, Ваш идеальный вес #{ideal_weight}"
end