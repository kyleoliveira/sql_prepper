class Array

  # This adds a quick shorthand for 1..self.length.
  # @return [Array] All items in the Array except the first one.
  def rest
    f, *r = *self
    r
  end

end

class Hash

  # @return [Hash] duplicate of self without entries that have nil values
  def compact
    self.select { |_, value| !value.nil? }
  end

  # @return [Hash] self without entries that have nil values
  def compact!
    self.reject! { |_, value| value.nil? }
  end

end

