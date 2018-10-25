require 'pry'
require_relative 'modules/instance_counter'
require_relative 'modules/validation'
require_relative 'modules/made'
require_relative 'modules/accessors'
# === Train ===
class Train
  include Made
  include InstanceCounter
  include Validation
  include Accessors

  attr_accessor :speed,
                :route

  attr_reader :number,
              :type,
              :wagons

  TRAIN_FORMAT = /^([a-z]{3}|[0-9]{3})-?([a-z]{2}|[0-9]{2})/i

  validate :number, :presence
  validate :number, :format, TRAIN_FORMAT
  validate :number, :type, String

  strong_attr_accessor       :route, Route
  attr_accessor_with_history :station

  @@trains_counter = {}

  def initialize(number)
    @number                       = number
    @wagons                       = []
    @speed                        = 0
    @route                        = nil
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
end
