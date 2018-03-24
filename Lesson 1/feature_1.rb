# идеальный вес

puts "Как Вас зовут?"
user_name = gets.chomp.capitalize

puts "#{user_name}, подскажите Ваш рост?"
user_height = gets.chomp.to_i

ideal_weight = user_height - 110

if ideal_weight < 0
  puts "#{user_name}, Ваш вес уже оптимальный"
else
  puts "#{user_name}, Ваш идеальный вес #{ideal_weight}"
end