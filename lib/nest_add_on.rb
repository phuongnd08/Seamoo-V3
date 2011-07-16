class Nest
  alias :get_s :get

  def get_i
    self.get.to_i
  end

  def get_b
    self.get.try(:to_b)
  end

  def set_with_awareness_of_nil(value)
    if value.nil?
      self.del
    else
      self.set_without_awareness_of_nil value
    end
  end

  alias_method_chain :set, :awareness_of_nil
end
