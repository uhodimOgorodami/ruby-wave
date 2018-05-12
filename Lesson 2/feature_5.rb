# Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?) Алгоритм опредления високосного года: www.adm.yar.ru

puts "Пожалуйста, введите день месяца:"
day = gets.chomp.to_i

puts "месяц:"
month = gets.chomp.to_i

puts "и год:"
year = gets.chomp.to_i

days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

days_in_months[1] = 29 if year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)

serial_number_od_date = 0
(0..month - 2).each do |i|
  serial_number_od_date += days_in_months[i]
end
serial_number_od_date += day

puts "Номер даты: #{serial_number_od_date}"
