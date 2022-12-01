# frozen_string_literal: true

module Enumerable
  def chunk_by(&block)
    result = [[]]
    each do |item|
      result << [] if block.call(item)
      result.last << item
    end
    result
  end
end
