require 'pry'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'validation'


class RailwayStationManagement

attr_accessor :stations,
              :trains,
              :routes,
              :wagons

  def initialize
    @stations = []
    @trains   = []
    @routes   = []
  end

  def start
    loop do
      menu_inerface
      choice = gets.chomp
      case choice
      when "1" then create_station
      when "2" then create_train
      when "3" then create_route
      when "4" then set_route_to_train
      when "5" then add_wagons
      when "6" then delete_wagons
      when "7" then move_on_route
      when "8" then list_of_stations
      when "9" then show_trains_on_station
      when "10" then add_station_to_route
      when "11" then remove_station_from_route
      when "12" then wagons_list_from_train
      when "13" then wagons_operations
      when "0" then break
      else
        puts "Ошибка! Попробуйте снова"
      end
    end
  end

  # комманды в меню
  # - Создавать станции
  # - Создавать поезда
  # - Создавать маршруты и управлять
  # станциями в нем (добавлять, удалять)
  # - Назначать маршрут поезду
  # - Добавлять вагоны к поезду
  # - Отцеплять вагоны от поезда
  # - Перемещать поезд по маршруту вперед и назад
  # - Просматривать список станций и список поездов
  # на станции

  def menu_inerface
    puts "================================"
    puts "Создать станцию:             [1]"
    puts "Создать поезд:               [2]"
    puts "Создать маршрут:             [3]"
    puts "Присвоить маршрут поезду:    [4]"
    puts "Добавить вагон к поезду:     [5]"
    puts "Отценпить вагон от поезда:   [6]"
    puts "Перемещение по маршруту:     [7]"
    puts "Cписок станций:              [8]"
    puts "Список поездов на станции:   [9]"
    puts "Добавить станцию к маршруту: [10]"
    puts "Удалить станцию из маршрута: [11]"
    puts "Список вагонов у поезда:     [12]"
    puts "Операции с вагонами:         [13]"
    puts "Выход из программы:          [0]"
    puts "================================"
  end

  #12
  def wagons_list_from_train
    unless @trains.any?
      puts 'нечего выводить, создайте поезда, присвойте им вагоны'
      return
    else
      puts "выберите индекс поезда:"
      list_of_trains
      choice = gets.chomp.to_i
    end
    if @trains[choice].wagons.empty?
      puts "у выбранного поезда нет прицепленных вагонов"
      return
    end
    case
    when @trains[choice].type == :passenger
      @trains[choice].wagon_list do |wagon|
        puts "#{wagon.free_seats} - у вагона №#{wagon.number} \u{1F683}"
      end
    when @trains[choice].type == :cargo
      @trains[choice].wagon_list do |wagon|
        puts "#{wagon.occupied_volume} - у вагона №#{wagon.number} \u{1F683}"
      end
    end
  end

  #13
  def wagons_operations
    unless @trains.any?
      puts 'сперва создайте поезда, присвойте им вагоны'
      return
    else
      puts "выберите индекс поезда:"
      list_of_trains
      train = gets.chomp.to_i
    end
    if @trains[train].wagons.empty?
      puts "у выбранного поезда нет прицепленных вагонов"
      return
    end
    case
    when @trains[train].type == :passenger
      puts "выберите вагон:"
      @trains[train].wagon_list_with_index
      wagon_choice = gets.chomp.to_i
      puts 'сколько мест занять?'
      count = gets.chomp.to_i
      wagon = @trains[train].wagons[wagon_choice]
      wagon.take_seat(count)
      wagon.free_seats
    when @trains[train].type == :cargo
      puts "выберите вагон:"
      @trains[train].wagon_list_with_index
      wagon_choice = gets.chomp.to_i
      puts 'сколько объема занять?'
      cargo_action = gets.chomp.to_i
      wagon = @trains[train].wagons[wagon_choice]
      wagon.cargo_load(cargo_action)
      wagon.free_volume
    end
  end

  #1
  def create_station
    attempt = 0
    begin
      puts "название станции:"
      new_station = gets.chomp
      if new_station == ''
        puts "Вы ничего не ввели. Попробуйте снова."
      else
        @stations << Station.new(new_station)
        puts "\u{1F689} cтанция - «#{new_station}» создана"
      end
    rescue RuntimeError => e
      attempt += 1
      puts e.inspect
      retry if attempt < 3
    end
  end

  #2
  def create_train
    attempt = 0
    begin
      puts "Введите номер поезда: "
      number = gets.chomp
      puts "Укажите тип поезда ([p] - пассажирский, [c] - грузовой): "
      type_of_train = gets.chomp
      if type_of_train == 'p'
        train = PassengerTrain.new(number)
        @trains << train
        puts "\u{1F682} пассажирский поезд - №#{number} создан"
      elsif type_of_train == 'c'
        train = CargoTrain.new(number)
        @trains << train
        puts "Грузовой поезд - №#{number} успешно создан"
      else
        puts "Некорректно был введен номер поезда, либо его тип. Попробуйте снова"
      end
    rescue RuntimeError => e
      attempt += 1
      puts e.inspect
      retry if attempt < 3
    end
  end

  #3
  def create_route
    unless @stations.any?
      puts "Текущее количество станций = #{@staions.to_i}. Маршрут можно создать из 2-х и более станций."
      return
    else
      list_of_stations
    end
    puts "Выберите индекс начальной станции из списика."
    start_s = gets.chomp.to_i
    start_station = @stations[start_s]
    if @stations.include?(start_station)
      puts "Начальная станция - «#{start_station.name}»."
    else
      puts "Индекс задан неверно. Попробуйте снова."
      return
    end
    puts "Выберите индекс конечной станции."
    end_s = gets.chomp.to_i
    end_station = @stations[end_s]
    if @stations.include?(end_station) && end_station != start_station
      puts "Конечная станция - «#{end_station.name}»."
    elsif end_station == start_station
      puts "Маршрут не может состоять из одинаковых начальной и конечной станции."
      return
    else
      puts "Индекс задан неверно. Попробуйте снова."
      return
    end
    new_route = Route.new(start_station, end_station)
    @routes << new_route
    puts "Маршрут «#{start_station.name} - #{end_station.name}» создан."
  end

  #4
  def set_route_to_train
    unless list_of_trains.any?
      puts "Создайте поезд для присвоения маршрута"
      return
    else
      puts "Выберите и введите индекс поезда, которому хотите присвоить маршрут: "
      train_choice = gets.chomp.to_i
    end
    unless train_choice == '' || @trains.include?(@trains[train_choice])
      puts "Неверно задан индекс поезда. Попробуйте снова."
      return
    else
      puts "#{list_of_routes}"
    end
    unless @routes.any?
      puts "Нет созданных маршрутов, создайте новый."
      return
    else
      puts "Выберите индекс маршрута: "
      route_choice = gets.chomp.to_i
    end
    unless route_choice == '' || @routes.include?(@routes[route_choice])
      puts "Неверно задан индекс маршрута. Попробуйте снова."
    else
      @trains[train_choice].take_route(@routes[route_choice])
      puts "К поезду #{@trains[train_choice].number} успешно присвоен маршрут «#{@routes[route_choice].station_list[0].name} - #{@routes[route_choice].station_list[-1].name}»"
      @routes[route_choice].station_list[0].arrive(@trains[train_choice])
    end
  end


  def list_of_trains
    @trains.each_with_index do |train, index|
      puts "[#{index}] - поезд №#{train.number}"
    end
  end

  def list_of_routes
    @routes.each_with_index do |route, index|
      puts "[#{index}] - маршрут «#{route.station_list[0].name} - #{route.station_list[-1].name}»"
    end
  end

  #8
  def list_of_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] - станция «#{station.name}»"
    end
  end



  #10
  def add_station_to_route
    unless @routes.any?
      puts "Нет созданных маршрутов, создайте новый."
      return
    else
      list_of_routes
    end
    puts "Выберите индекс маршрута: "
    route_choice = gets.chomp.to_i
    route = @routes[route_choice]
    route_name = route.station_list[0].name + " - " + route.station_list[-1].name
    if @routes.include?(route)
      puts "Добавлять станцию будем к маршруту #{route_name}"
    else
      puts "Неверно задан индекс маршрута. Попробуйте снова."
      return
    end
    puts "Теперь необходимо выбрать станцию: "
    list_of_stations
    station_choice = gets.chomp.to_i
    station = @stations[station_choice]
    if @stations.include?(station)
      route.add_midway_station(station)
      puts "К маршруту «#{route_name}» успешно добавлена станция «#{station.name}»"
    else
      puts "Неверно задан индекс станции. Попробуйте снова."
      return
    end
  end

  #11
  def remove_station_from_route
    unless @routes.any?
      puts "Нет созданных маршрутов, создайте новый."
      return
    else
      list_of_routes
    end
    puts "Чтобы удалить станцию из маршрута - выберите и введите индекс маршрута: "
    route_choice = gets.chomp.to_i
    if route_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      puts "Список доступных станций для удаления #{@routes[route_choice].station_list}"
    end
    puts "Теперь необходимо выбрать станцию, которую хотим убрать из списка: "
    station_choice = gets.chomp.to_i
    if station_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      @routes[route_choice].remove_midway_station(@stations[station_choice])
      puts "Станция #{@stations[station_choice].name} успешно удалена из маршрута «#{@routes[route_choice].station_list[0].name} - #{@routes[route_choice].station_list[-1].name}»"
    end
  end

  #5
  def add_wagons
    attempt = 0
    begin
      unless @trains.any?
        puts "нет поездов, чтобы прицепить вагон"
        return
      else
        list_of_trains
        puts "выберите индекс поезда:"
        train_choice = gets.chomp.to_i
      end
      puts "выбран поезд №#{@trains[train_choice].number} тип #{@trains[train_choice].type}"
      puts "присвойте вагону номер:"
      num = gets.chomp
      if @trains[train_choice].type == :cargo
        puts "укажите объем грузового вагона:"
        cargo_volume = gets.chomp
        cargo_wagon = CargoWagon.new(num, cargo_volume)
        @trains[train_choice].add_wagon(cargo_wagon)
        puts "\u{1F683} №#{num} успешно прицеплен к поезду №#{@trains[train_choice].number}"
      elsif @trains[train_choice].type == :passenger
        puts "укажите количество мест в вагоне:"
        seats_count = gets.chomp
        passenger_wagon = PassengerWagon.new(num, seats_count)
        @trains[train_choice].add_wagon(passenger_wagon)
        puts "\u{1F683} №#{num} успешно прицеплен к поезду №#{@trains[train_choice].number}"
      else
        puts "Попробуйте снова"
      end
    end
  rescue RuntimeError => e
    attempt += 1
    puts e.inspect
    retry if attempt < 3
  end

  #6
  def delete_wagons
    unless @trains.any? || @wagons.any?
      puts "добавьте поезда с прицепленными вагонами"
      return
    else
      list_of_trains
    end
    puts "У какого поезда будем отцеплять вагон? Введите индекс: "
    train_choice = gets.chomp.to_i
    if train_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      @trains[train_choice].wagons.each_with_index do |wagon, index|
        puts "#{index} - #{wagon}"
      end
    end
    puts "Чтобы отцепить нужный вагон - выберете его индекс: "
    wagon_choice = gets.chomp.to_i
    if wagon_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      @trains[train_choice].remove_wagon(@trains[train_choice].wagons[wagon_choice])
      puts "#{wagon_choice} был успешно отцеплен"
    end
  end

  #7
  def move_on_route
    unless @trains.any?
      puts "нет поездов с маршрутами"
      return
    else
      list_of_trains
    end
    puts "Какой поезд будем двигать? Введите индекс: "
    train_choice = gets.chomp.to_i
    train = @trains[train_choice]
    route = train.route
    if @trains.include?(train)
      puts "Будем двигать №#{train.number}."
    else
      puts "Вы не указали индекс поезда. Попробуйте снова."
    end
    puts "Вперед - введите [1],\nНазад - введите [2]: "
    move_choice = gets.chomp.to_i
    if move_choice == 1
      train.go_next
    elsif move_choice == 2
      train.go_back
    else
      puts "Ошибка!"
    end
  end

  #9
  def show_trains_on_station
    unless @stations.any?
      puts "в программе нет созданных станций"
      return
    else
      list_of_stations
    end
    puts "Выберете индекс станции, на которой хотите увидеть список поездов: "
    station_choice = gets.chomp.to_i
    if @stations.include?(@stations[station_choice])
      puts "Текущий список поездов: #{@stations[station_choice].train_list}"
    else
      puts "Вы не выбрали индекс, попробуйте снова"
    end
  end

end

test = RailwayStationManagement.new
test.start
