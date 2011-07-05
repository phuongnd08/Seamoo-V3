class String
  def to_b
    !! (self =~ /\A(true|1)\Z/i)
  end
end
