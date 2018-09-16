# === Train ===
class Train
  attr_accessor :speed, :route
  attr_reader :number, :type, :wagons, :speed

  def initialize(number)
    @number = number
    @type = type
    @wagon = 0
    @wagons = []
    @speed = 0
  end

  def increase_speed(speed)
    @speed += speed
  end

  def stop_train
    @speed = 0
  end

  def add_wagon(wagon)
    if @speed.zero?
      @wagons << @wagon
    else
      puts "Для прицепки вагона - необходимо остановить поезд, текущая скорость #{@speed}"
    end
  end

  def remove_wagon(wagon)
    if @speed.zero? && @wagons != 0
      @wagons.delete(wagon)
    elsif @speed.zero? && @wagons.empty?
      puts "Нелья отцепить несуществующий вагон, на данный момент вагонов у поезда #{@wagons}"
    else
      puts "Для отцепки вагона - необходимо остановить поезд, текущая скорость #{@speed}"
    end
  end

  def take_route(route)
    @route = route
    @station_index = 0
    #current_station.arrive(self)
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

  protected

  # определение текущей, следующей и предыдущей станции поездом - это внутренняя механика,
  # то есть клиентский код по-моему не должен об этом знать,
  # методы для опередния по логике не будут вызываться со стороны клиента


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
