module Validation
  def valid?
    validate!
  rescue StandardError
    false
  end
end
