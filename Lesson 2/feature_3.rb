# Заполнить массив числами фибоначчи до 100

fibonacci = [0, 1]

loop do
  next_fibonacci = fibonacci[-1] + fibonacci[-2]
  break if next_fibonacci >= 100
  fibonacci << next_fibonacci
end