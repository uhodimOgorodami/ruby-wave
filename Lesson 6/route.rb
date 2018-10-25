require_relative 'modules/validation'
# === Route ===
class Route
  include Validation
  attr_reader :midway_station_list

  validate :stations, :presence

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
  end

  def add_station(station)
    @stations.insert(-2, station) unless @stations.include?(station)
  end

  def remove_station(station)
    @stations.delete(station) if @stations.include?(station)
  end

  def station_list
    @stations.each { |station| puts station.name }
  end
end
