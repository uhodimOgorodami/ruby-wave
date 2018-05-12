# Сумма покупок. Пользователь вводит поочередно название товара, цену за единицу и кол-во купленного товара (может быть нецелым числом).
# Пользователь может ввести произвольное кол-во товаров до тех пор, пока не введет "стоп" в качестве названия товара.
# На основе введенных данных требуетеся:
# Заполнить и вывести на экран хеш, ключами которого являются названия товаров, а значением - вложенный хеш,
# содержащий цену за единицу товара и кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
# Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".



amount_of_purchases = {}

loop do
  puts "Введите название товара (для остановки введите 'стоп'): "
  product_name = gets.chomp
  break if product_name == "стоп"
  puts "Введите стоимость товара: "
  product_price = gets.chomp.to_f
  puts "Введите количество купленного товара: "
  product_count = gets.chomp.to_f
  amount_of_purchases[product_name] = {:product_price => product_price, :product_count => product_count}
end

puts amount_of_purchases.inspect

total_amount = 0

amount_of_purchases.each do |name, count|
  total_sum = count[:product_price] * count[:product_count]
  puts "Товар: #{name}, его цена: #{total_sum} $"
  total_amount += total_sum
end

puts "Итоговая сумма покупок: #{total_amount}"
