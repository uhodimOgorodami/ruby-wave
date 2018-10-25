require 'pry'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'modules/validation'

# main program
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
      when '1' then create_station
      when '2' then create_train
      when '3' then create_route
      when '4' then set_route_to_train
      when '5' then add_wagons
      when '6' then delete_wagons
      when '7' then move_on_route
      when '8' then list_of_stations
      when '9' then show_trains_on_station
      when '10' then add_station_to_route
      when '11' then remove_station_from_route
      when '12' then wagons_list_from_train
      when '13' then wagons_operations
      when '0' then break
      else
        puts 'Ошибка! Попробуйте снова'
      end
    end
  end

  def menu_inerface
    puts 'Создать станцию:             [1]'
    puts 'Создать поезд:               [2]'
    puts 'Создать маршрут:             [3]'
    puts 'Присвоить маршрут поезду:    [4]'
    puts 'Добавить вагон к поезду:     [5]'
    puts 'Отценпить вагон от поезда:   [6]'
    puts 'Перемещение по маршруту:     [7]'
    puts 'Cписок станций:              [8]'
    puts 'Список поездов на станции:   [9]'
    puts 'Добавить станцию к маршруту: [10]'
    puts 'Удалить станцию из маршрута: [11]'
    puts 'Список вагонов у поезда:     [12]'
    puts 'Операции с вагонами:         [13]'
    puts 'Выход из программы:          [0]'
  end

  # 12
  def wagons_list_from_train
    return puts 'создайте поезда, присвойте вагоны' unless @trains.any?

    puts 'выберите индекс поезда:'
    list_of_trains
    choice = gets.chomp.to_i
    train = @trains[choice]
    puts 'нет прицепленных вагонов' if train.wagons.empty?
    if train.type == :passenger
      train.wagon_list do |wagon|
        puts "#{wagon.free_seats} - у вагона №#{wagon.number} \u{1F683}"
      end
    elsif train.type == :cargo
      train.wagon_list do |wagon|
        puts "#{wagon.occupied_volume} - у вагона №#{wagon.number} \u{1F683}"
      end
    end
  end

  # 13
  def wagons_operations
    return puts 'создайте поезда, присвойте вагоны' unless @trains.any?

    puts 'выберите индекс поезда:'
    list_of_trains
    choice = gets.chomp.to_i
    train = @trains[choice]
    puts 'нет прицепленных вагонов' if train.wagons.empty?

    if train.type == :passenger
      puts 'выберите вагон:'
      train.wagon_list_with_index
      wagon_choice = gets.chomp.to_i
      puts 'сколько мест занять?'
      count = gets.chomp.to_i
      wagon = train.wagons[wagon_choice]
      wagon.take_seat(count)
      wagon.free_seats
    elsif train.type == :cargo
      puts 'выберите вагон:'
      train.wagon_list_with_index
      wagon_choice = gets.chomp.to_i
      puts 'сколько объема занять?'
      cargo_action = gets.chomp.to_i
      wagon = train.wagons[wagon_choice]
      wagon.cargo_load(cargo_action)
      wagon.free_volume
    end
  end

  # 1
  def create_station
    puts 'название станции:'
    new_station = gets.chomp
    @stations << Station.new(new_station)
    puts "\u{1F689} cтанция - «#{new_station}» создана"
  rescue RuntimeError => e
    puts e.inspect
  end

  # 2
  def create_train
    puts 'Введите номер поезда: '
    number = gets.chomp
    puts 'тип поезда:[p] пассажирский, [c] грузовой?'
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
      puts 'Ошибка. Попробуйте снова'
    end
  rescue RuntimeError => e
    puts e.inspect
  end

  # 3
  def create_route
    return puts 'Маршрут можно создать из 2-х и более станций' unless @stations.any?

    list_of_stations
    puts 'Выберите индекс начальной станции из списика.'
    start_s = gets.chomp.to_i
    start_station = @stations[start_s]
    if @stations.include?(start_station)
      puts "Начальная станция - «#{start_station.name}»."
    else
      puts 'Индекс задан неверно. Попробуйте снова.'
      return
    end
    puts 'Выберите индекс конечной станции.'
    list_of_stations
    end_s = gets.chomp.to_i
    end_station = @stations[end_s]
    if @stations.include?(end_station) && end_station != start_station
      puts "Конечная станция - «#{end_station.name}»."
    elsif end_station == start_station
      puts 'Конечная и начальная станции совпадают. Ошибка'
      return
    else
      puts 'Индекс задан неверно. Попробуйте снова.'
      return
    end
    new_route = Route.new(start_station, end_station)
    @routes << new_route
    puts "Маршрут «#{start_station.name} - #{end_station.name}» создан."
  end

  # 4
  def set_route_to_train
    return puts 'Создайте поезд для присвоения маршрута' unless list_of_trains.any?

    puts 'Выберите индекс поезда, которому хотите присвоить маршрут:'
    train_choice = gets.chomp.to_i
    train = @trains[train_choice]
    return puts 'Неверно задан индекс поезда. Попробуйте снова.' unless @trains.include?(train)

    list_of_routes
    return puts 'Нет созданных маршрутов, создайте новый.' unless @routes.any?

    puts 'Выберите индекс маршрута: '
    route_choice = gets.chomp.to_i
    route = @routes[route_choice]
    return puts 'Неверно задан индекс маршрута. Попробуйте снова.' unless @routes.include?(route)

    train.take_route(route)
    route_name = "#{route.station_list[0].name} - #{route.station_list[-1].name}"
    puts "поезду #{train.number} присвоен маршрут «#{route_name}»"
    route.station_list[0].arrive(train)
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

  # 8
  def list_of_stations
    @stations.each_with_index do |station, index|
      puts "[#{index}] - станция «#{station.name}»"
    end
  end

  # 10
  def add_station_to_route
    return puts 'Нет созданных маршрутов, создайте новый.' unless @routes.any?

    list_of_routes
    puts 'Выберите индекс маршрута: '
    route_choice = gets.chomp.to_i
    route = @routes[route_choice]
    route_name = "#{route.station_list[0].name} - #{route.station_list[-1].name}"
    return puts 'Ошибка. Попробуйте снова.' unless @routes.include?(route)

    puts 'Теперь необходимо выбрать станцию: '
    list_of_stations
    station_choice = gets.chomp.to_i
    station = @stations[station_choice]
    return puts 'Ошибка. Попробуйте снова.' unless @stations.include?(station)

    route.add_midway_station(station)
    puts "К маршруту «#{route_name}» успешно добавлена станция «#{station.name}»"
  end

  # 11
  def remove_station_from_route
    return puts 'Нет созданных маршрутов, создайте новый.' unless @routes.any?

    list_of_routes
    puts 'для удаления станции - введите индекс маршрута:'
    route_choice = gets.chomp.to_i
    route = @routes[route_choice]
    return puts 'Вы не выбрали ничего, попробуйте снова' if route_choice.nil?

    puts "доступные станции д/удаления #{route.station_list}"
    puts 'Теперь необходимо выбрать станцию, которую хотим убрать из списка:'
    station_choice = gets.chomp.to_i
    station = @stations[station_choice]
    return puts 'Вы не выбрали ничего, попробуйте снова' if station_choice.nil?

    @routes[route_choice].remove_midway_station(@stations[station_choice])
    route_name = "#{route.station_list[0].name} - #{route.station_list[-1].name}"
    puts "Станция #{station.name} успешно удалена из маршрута «#{route_name}»"
  end

  # 5
  def add_wagons
    return puts 'нет поездов, чтобы прицепить вагон' unless @trains.any?

    list_of_trains
    puts 'выберите индекс поезда:'
    train_choice = gets.chomp.to_i
    train = @trains[train_choice]
    puts "выбран поезд №#{train.number} тип #{train.type}"
    puts 'присвойте вагону номер:'
    num = gets.chomp
    if train.type == :cargo
      puts 'укажите объем грузового вагона:'
      cargo_volume = gets.chomp
      cargo_wagon = CargoWagon.new(num, cargo_volume)
      @trains[train_choice].add_wagon(cargo_wagon)
      puts "\u{1F683} №#{num} успешно прицеплен к поезду №#{train.number}"
    elsif train.type == :passenger
      puts 'укажите количество мест в вагоне:'
      seats_count = gets.chomp
      passenger_wagon = PassengerWagon.new(num, seats_count)
      train.add_wagon(passenger_wagon)
      puts "\u{1F683} №#{num} успешно прицеплен к поезду №#{train.number}"
    else
      puts 'Попробуйте снова'
    end
  rescue RuntimeError => e
    puts e.inspect
  end

  # 6
  def delete_wagons
    return puts 'добавьте поезда с вагонами' unless @trains.any? || @wagons.any?

    list_of_trains
    puts 'выберите индекс поезда:'
    train_choice = gets.chomp.to_i
    train = @trains[train_choice]
    return puts 'Вы не выбрали ничего, попробуйте снова' if train_choice.nil?

    train.wagons.each_with_index { |wagon, index| puts "#{index} - #{wagon}" }
    puts 'Чтобы отцепить нужный вагон - выберете его индекс: '
    wagon_choice = gets.chomp.to_i
    wagon = train.wagons[wagon_choice]
    return puts 'Вы не выбрали ничего, попробуйте снова' if wagon.nil?

    train.remove_wagon(wagon)
    puts "#{wagon} был успешно отцеплен"
  end

  # 7
  def move_on_route
    return puts 'нет поездов с маршрутами' unless @trains.any?

    puts 'Какой поезд будем двигать? Введите индекс:'
    list_of_trains
    train_choice = gets.chomp.to_i
    train = @trains[train_choice]
    puts 'Ошибка. Попробуйте снова.' unless @trains.include?(train)
    puts "Вперед - введите [1],\nНазад - введите [2]: "
    move_choice = gets.chomp.to_i
    if move_choice == 1
      train.go_next
    elsif move_choice == 2
      train.go_back
    else
      puts 'Ошибка!'
    end
  end

  # 9
  def show_trains_on_station
    return puts 'в программе нет созданных станций' unless @stations.any?

    puts 'Выберете индекс станции, на которой хотите увидеть список поездов:'
    list_of_stations
    station_choice = gets.chomp.to_i
    station = @station[station_choice]
    puts 'Вы не выбрали индекс, попробуйте снова' unless @stations.include?(station)
    puts "Текущий список поездов: #{station.train_list}"
  end
end

test = RailwayStationManagement.new
test.start
