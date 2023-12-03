#!/usr/bin/env ruby

# Utility script to download and show the input for a given year and day.
# This also always bypasses the cache.

require_relative 'utils/ruby/Aoc'
include Aoc


year, day = ARGV

unless year && day
  puts "Usage: #{$0} YEAR DAY"
  exit 1
end

input = get_input(year:, day:, ignore_cache: true)

puts input