class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, TRAIN_FORMAT
  validate :number, :type, String

  def initialize(number)
    super
    @type = :cargo
  end
end
