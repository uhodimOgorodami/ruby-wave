require_relative 'validation'
require_relative 'made'
require_relative 'instance_counter'
# === Train ===
class Train
  include Made
  include InstanceCounter
  include Validation

  attr_accessor :speed,
                :route

  attr_reader :number,
              :type,
              :wagons

  @@trains_counter = {}

  TRAIN_FORMAT = /^([a-z]{3}|[0-9]{3})-?([a-z]{2}|[0-9]{2})/i

  def initialize(number)
    @number                       = number
    @type                         = type
    @wagons                       = []
    @speed                        = 0
    @@trains_counter[self.number] = self
    validate!
  end

  def self.find(number)
    @@trains_counter[number]
  end

  def increase_speed(speed)
    @speed += speed
  end

  def stop_train
    @speed = 0
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon)
  end

  def take_route(route)
    @route = route
    @current_station = @route.station_list.first
  end

  def current_station
    route.station_list.each do |x|
      @current_station = if x.train_list.include?(self)
                           x
                         else
                           @route.station_list.first
                         end
    end
  end

  def go_next
    if @current_station == @route.station_list.last
      puts 'Это конечная, поезд дальше не идет.'
    else
      @current_station = next_station
      puts "Поезд приехал на станцию #{@current_station.name}"
    end
  end

  def go_back
    if @current_station == @route.station_list.first
      puts 'Поезд не может поехать назад, поезд находится на начальной станции.'
    else
      @current_station = previous_station
      puts "Поезд возвращается на станцию #{@current_station.name}."
    end
  end

  def next_station
    @route.station_list[@route.station_list.index(@current_station) + 1]
  end

  def previous_station
    @route.station_list[@route.station_list.index(@current_station) - 1]
  end

  def wagon_list
    @wagons.each { |wagon| yield wagon }
  end

  def wagon_list_with_index
    @wagons.each_with_index do |wagon, index|
      puts "[#{index}] - вагон «#{wagon.number}»"
    end
  end

  protected

  def validate!
    raise 'Номер поезда не может быть пустым' if number.to_s.empty?
    raise 'Номер поезда задан в неверном формате, попробуйте еще раз' if number !~ TRAIN_FORMAT
  end
end
