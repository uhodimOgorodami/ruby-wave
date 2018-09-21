require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'


class RailwayStationManagement

attr_accessor :stations, :trains, :routes, :wagons

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
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
    puts "Для создания станции - введите 1"
    puts "Для создания поезда - введите 2"
    puts "Для создания и управления маршрутом - введите 3"
    puts "Для присвоения маршрута поезду - введите 4"
    puts "Для добавления станции к маршруту - введите 10"
    puts "Для удаления станции из маршрута - введите 11"
    puts "Для добавления вагона к поезду - введите 5"
    puts "Чтобы отцепить вагон от поезда - введите 6"
    puts "Для перемещения поезда по маршруту - введите 7"
    puts "Для просмотра списка станций - введите 8"
    puts "Для просмотра списка поездов на станции - введите 9"
    puts "Для завершения программы - введите 0"
  end

  #1
  def create_station
    puts "Введите название станции: "
    new_station = gets.chomp
    if new_station == ''
      puts "Вы ничего не ввели. Попробуйте снова."
    else
      @stations << Station.new(new_station)
      puts "Станция - «#{new_station}» создана."
    end
  end

  #2
  def create_train
    puts "Введите номер поезда: "
    number = gets.chomp
    puts "Укажите тип поезда ([p] - пассажирский, [c] - грузовой): "
    type_of_train = gets.chomp
    if type_of_train == 'p'
      train = PassengerTrain.new(number)
      @trains << train
      puts "Пассажирский поезд - №#{number} успешно создан"
    elsif type_of_train == 'c'
      train = CargoTrain.new(number)
      @trains << train
      puts "Грузовой поезд - №#{number} успешно создан"
    else
      puts "Некорректно был введен номер поезда, либо его тип. Попробуйте снова"
    end
  end

  #3
  def create_route
    list_of_stations
    puts "Выберите индекс начальной станции из списика."
    start_s = gets.chomp.to_i
    puts "Начальная станция - «#{@stations[start_s].name}»."
    puts "Выберите индекс конечной станции."
    end_s = gets.chomp.to_i
    puts "Конечная - «#{@stations[end_s].name}»."
    new_route = Route.new(@stations[start_s], @stations[end_s])
    @routes << new_route
    puts "Маршрут «#{@stations[start_s].name} - #{@stations[end_s].name}» создан."
  end

  #4
  def set_route_to_train
    list_of_trains
    puts "Выберите и введите индекс поезда, которому хотите присвоить маршрут: "
    train_choice = gets.chomp.to_i
    if train_choice == ''
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      puts "#{list_of_routes}"
    end
    puts "Выберите индекс маршрута: "
    route_choice = gets.chomp.to_i
    if route_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
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
    list_of_routes
    puts "Выберите и введите индекс маршрута, чтобы добавить к нему станцию: "
    route_choice = gets.chomp.to_i
    if route_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      list_of_stations
    end
    puts "Теперь необходимо выбрать станцию: "
    station_choice = gets.chomp.to_i
    if station_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      @routes[route_choice].add_midway_station(@stations[station_choice])
      puts "К маршруту «#{@routes[route_choice].station_list[0].name} - #{@routes[route_choice].station_list[-1].name}» успешно добавлена станция #{@stations[station_choice].name}"
    end
  end

  #11
  def remove_station_from_route
    list_of_routes
    puts "Чтобы удалить станцию из маршрута - выберите и введите индекс маршрута: "
    route_choice = gets.chomp.to_i
    if route_choice.nil?
      puts "Вы не выбрали ничего, попробуйте снова"
    else
      puts "Список доступных станций для удаления #{@routes[route_choice].station_list.name}"
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
    list_of_trains
    puts "К какому поезду будем добавлять вагон? Введите индекс: "
    train_choice = gets.chomp.to_i
    puts "Выбран поезд №#{@trains[train_choice].number} тип #{@trains[train_choice].type}"
    if @trains[train_choice].type == :cargo
      puts "К #{@trains[train_choice]} можно добавлять только грузовые вагоны, так как поезд является грузовым"
      puts "Присоединяем вагон..."
      cargo_wagon = CargoWagon.new
      @trains[train_choice].add_wagon(cargo_wagon)
      puts "#{cargo_wagon} успешно прицеплен к поезду #{@trains[train_choice]}"
    elsif @trains[train_choice].type == :passenger
      puts "К #{@trains[train_choice]} можно добавлять только пассажирские вагоны, так как поезд является пассажирским"
      puts "Присоединяем вагон..."
      passenger_wagon = PassengerWagon.new
      @trains[train_choice].add_wagon(passenger_wagon)
      puts "#{passenger_wagon} успешно прицеплен к поезду #{@trains[train_choice]}"
    else
      puts "Попробуйте снова"
    end
  end

  #6
  def delete_wagons
    list_of_trains
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
    list_of_trains
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
    list_of_stations
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
