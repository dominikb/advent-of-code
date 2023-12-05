# frozen_string_literal: true

class SparseRange
  def initialize
    @min_indexed = Hash.new
  end

  def ranges
    @min_indexed.values
  end

  def gap?
    @min_indexed.size > 1
  end

  def gap
    gap = SparseRange.new
    @min_indexed.keys.sort.each_cons(2) do |min1, min2|
      r1 = @min_indexed[min1]
      r2 = @min_indexed[min2]
      gap.add(r1.max + 1..r2.min - 1)
    end
    gap
  end

  def to_a
    ranges.flat_map(&:to_a)
  end

  def size
    ranges.map(&:size).sum
  end

  def cover?(value)
    ranges.any? { _1.cover?(value) }
  end

  def add(range)
    old_range = @min_indexed[range.min]
    @min_indexed[range.min] = old_range.nil? ? range : range.combine(old_range)
    minimize
    self
  end

  private def minimize
    recurse = false
    @min_indexed.keys.combination(2) do |min, other_min|
      r1 = @min_indexed[min]
      r2 = @min_indexed[other_min]
      if r1 && r2 && r1 != r2 && (r1.overlaps?(r2) || r1.adjacent?(r2))
        new_range = r1.combine(r2)
        @min_indexed.delete(r1.min)
        @min_indexed.delete(r2.min)
        @min_indexed[new_range.min] = new_range

        recurse = true
      end
    end
    minimize if recurse
  end

  def to_s
    "SparseRange<#{ranges.to_s}>"
  end
  alias :inspect :to_s
end
