#!/usr/bin/env ruby

year, day = ARGV.map(&:to_i)

unless year && day
  puts "Usage: #{$0} <year> <day>"
  exit 1
end

Dir.chdir(__dir__ + '/../..') do
    system("./get_input.rb #{year} #{day}")
    system("mkdir -p #{year}/day#{day.to_s.rjust(2, '0')}/ruby")
    system("cp utils/ruby/_template.rb #{year}/day#{day.to_s.rjust(2, '0')}/ruby/solution.rb")
end