# определение треугольника прямым, опционально равнобедренным и равносторонним

puts "Задайте длину стороны а:"
a = gets.chomp.to_f
puts "Задайте длину стороны b:"
b = gets.chomp.to_f
puts "Задайте длину стороны c:"
c = gets.chomp.to_f

# возведение в степень
aa = a * a
bb = b * b
cc = c * c

# валидируем условием входящие значения длин треугольника

if  a + b <= c || b + c <= a || c + a <= b
  puts "Треугольника с такими параметрами #{a}, #{b}, #{c} - не существует"
else
  puts "Определяем тип треугольника"
end

# условие, проверяющее прямой ли треугольник
if aa == bb + cc || bb == aa + cc || cc == aa + bb
  puts "Тип треугольника - прямоугольный"
elsif  (a == b && b != c) || (b == c && b != a)
  puts "Тип треугольника - равнобедренный"
elsif  a == b && b == c && c == a
  puts "Треугольник равнобедренный и равносторонний"
else
  puts "Это не прямоугольный треугольник"
end