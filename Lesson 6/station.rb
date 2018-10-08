require_relative 'validation'

class Station

  include Validation

  attr_reader   :name
  attr_accessor :train_list

  STATION_FORMAT = /^[a-z]*|[а-я]*$/i

  @@stations_counter = []

  def self.all
    @@stations_counter
  end

  def initialize(name)
    @name       = name
    @train_list = []
    @@stations_counter << self
    validate!
  end

  def arrive(train)
    @train_list << train unless @train_list.include?(train)
  end

  def train_list_by_type(type)
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

  protected

  def validate!
    raise "Название станции не может быть пустым" if name.to_s.empty?
    raise "название не может содержать спецсимволы" if name !~ STATION_FORMAT
    raise "название не более 10 символов" if name.size > 10
    raise "название не менее 3-х символов" if name.size < 3
    true
  end

end
