class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def adjacent?(other)
    max + 1 == other.min || other.max + 1 == min
  end

  def product(other)
    to_a.product(other.to_a)
  end

  def combine(other)
    new_min = other.min < min ? other.min : min
    new_max = other.max > max ? other.max : max
    new_min..new_max
  end

  class << self
    def combine_all(ranges)
      ranges = ranges.sort_by(&:min)
      out = ranges.pop
      count_since_combination = 0
      loop do
        head = ranges.pop
        if out.overlaps?(head)
          out = head.combine(out)
        else
          count_since_combination += 1
          ranges << head
        end
        return nil if count_since_combination >= ranges.size
        break if ranges.empty?
      end
      out
    end
  end
end
