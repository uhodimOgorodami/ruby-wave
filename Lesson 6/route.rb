require_relative 'validation'
# === Route ===
class Route
  include Validation
  attr_reader :midway_station_list

  def initialize(first_station, last_station)
    @first_station       = first_station
    @last_station        = last_station
    @midway_station_list = []
    validate!
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

  protected

  def validate!
    error_message = 'Маршрут не может быть создан без станций'
    raise error_message if @first_station.nil? || @last_station.nil?

    true
  end
end
