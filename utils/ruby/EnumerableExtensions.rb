# frozen_string_literal: true

module Enumerable
  def chunk_by(separator = nil, keep_separator: false, &block)
    should_chunk =
      case separator
      in Enumerable then ->(item) { separator.include? item }
      in x then ->(item) { x == item }
      else block
      end

    result = [[]]
    each do |item|
      if should_chunk.call(item)
        result << []
        result.last << item if keep_separator
      else
        result.last << item
      end
    end
    result
  end

  def second
    drop(1).first
  end

  def third
    drop(2).first
  end

end
