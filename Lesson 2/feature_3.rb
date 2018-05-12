# Заполнить массив числами фибоначчи до 100

fib_array = [0, 1]
fib_num = 1

while fib_num <= 100
  fib_array << fib_num
  fib_num = fib_array[-1] + fib_array[-2]
end

puts fib_array
