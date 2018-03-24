# вычисляем квадратный корень

puts "Задайте коэффициент a:"
a = gets.chomp.to_f

puts "Задайте коэффициент b:"
b = gets.chomp.to_f

puts "Задайте коэффициент c:"
c = gets.chomp.to_f

d = b**2 - 4 * a * c

if d > 0
  puts "Дискриминант = #{d}"
  puts "x1 = #{(-1 * b + Math.sqrt(d)) / (2 * a)}"
  puts "x2 = #{(-1 * b - Math.sqrt(d)) / (2 * a)}"
elsif  d.zero?
  puts "Дискриминант = #{d}"
  puts "x = #{(- b - d) / (2 * a)}"
else
  d < 0
  puts "Дискриминант = #{d}, уравнение не имеет корней"
end