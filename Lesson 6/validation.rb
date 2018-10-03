module Validation
  def valid?
    validate!
  rescue
    false
  end
end
