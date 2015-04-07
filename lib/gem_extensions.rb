class Array

  # This adds a quick shorthand for 1..self.length.
  # @return [Array] All items in the Array except the first one.
  def rest
    f, *r = *self
    r
  end

end



