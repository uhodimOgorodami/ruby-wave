require_relative 'modules/validation'

class Station
  include Validation

  attr_reader   :name
  attr_accessor :train_list

  STATION_FORMAT = /^[a-z]*|[а-я]*$/i

  validate :name, :presence
  validate :name, :format, STATION_FORMAT
  validate :name, :type, String

  def self.all
    @@stations_counter
  end

  @@stations_counter = []

  def initialize(name)
    @name       = name
    @train_list = []
    @@stations_counter << self
    validate!
  end

  def arrive(train)
    @train_list << train unless @train_list.include?(train)
  end

  def departure(train)
    @train_list.delete(train) if @train_list.include?(train)
  end

  def trains_list_at_station
    @trains.each { |train| yield train }
  end
end
