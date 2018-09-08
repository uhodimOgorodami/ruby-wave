# === Station ===

class Station
  attr_reader :name
  attr_accessor :train_list

  def initialize(name)
    @name = name
    @train_list = []
  end

  def arrive(train)
    @train_list << train unless @train_list.include?(train)
  end

  def train_list_by_type(type = '')
    if type == 'cargo'
      @train_list.find_all { |type| type == 'cargo' }
    elsif type == 'passenger'
      @train_list.find_all { |type| type == 'passenger' }
    else
      @train_list
    end
  end

  def departure(train)
    @train_list.delete(train) if @train_list.include?(train)
  end
end

# === Route ===
class Route
  attr_reader :midway_station_list

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @midway_station_list = []
  end

  def add_midway_station(station)
    midway_station_list << station unless midway_station_list.include?(station)
  end

  def remove_midway_station(station)
    midway_station_list.delete(station) if midway_station_list.include?(station)
  end

  def station_list
    [@first_station, @last_station].insert(1, *midway_station_list)
  end
end

# === Train ===
class Train
  attr_accessor :speed, :route
  attr_reader :number, :type, :wagons

  def initialize(number, type, wagons = 0)
    @number = number
    @type = type
    @wagons = wagons.to_i
    @speed = 0
  end

  def speed
    @speed += 25
  end

  def stop_train
    @speed = 0
  end

  def wagons_count
    if @wagons == 0
      puts 'К поезду не прицеплен ни один вагон'
    else
      @wagons
    end
  end

  def add_wagon
    if @speed == 0
      @wagons += 1
    else
      puts "Для прицепки вагона - необходимо остановить поезд, текущая скорость #{@speed}"
    end
  end

  def remove_wagon
    if @speed == 0 && @wagons != 0
      @wagons -= 1
    elsif @speed == 0 && @wagons == 0
      puts "Нелья отцепить несуществующий вагон, на данный момент вагонов у поезда #{@wagons}"
    else
      puts "Для отцепки вагона - необходимо остановить поезд, текущая скорость #{@speed}"
    end
  end

  def route=(route)
    @route = route
    @station_index = 0
    current_station.arrive(self)
  end

  def go_next
    return if last_station?
    current_station.arrive(self)
    @station_index += 1
    current_station.arrive(self)
  end

  def go_back
    return if first_station?
    current_station.departure(self)
    @station_index -= 1 if @station_index > 0
    current_station.arrive(self)
  end

  def current_station
    @route.station_list[@station_index]
  end

  def next_station
    @route.station_list[@station_index + 1]
  end

  def previous_station
    @route.station_list[@station_index - 1] if @station_index > 0
  end

  def first_station?
    current_station == @route.station_list.first
  end

  def last_station?
    current_station == @route.station_list.last
  end
end