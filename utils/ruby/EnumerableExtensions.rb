# frozen_string_literal: true

module Enumerable
  def not_empty?
    !empty?
  end

  # File activesupport/lib/active_support/core_ext/enumerable.rb, line 103
  def index_by
    if block_given?
      result = {}
      each { |elem| result[yield(elem)] = elem }
      result
    else
      to_enum(:index_by) { size if respond_to?(:size) }
    end
  end

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
