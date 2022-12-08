class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def product(other)
    to_a.product(other.to_a)
  end
end
