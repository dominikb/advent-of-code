#!/usr/bin/env ruby

year, day = ARGV.map(&:to_i)

unless year && day
  puts "Usage: #{$0} <year> <day>"
  exit 1
end

Dir.chdir(__dir__ + "/../..") do
  system("./get_input.rb #{year} #{day}")
  system("mkdir -p #{year}/day#{day.to_s.rjust(2, "0")}/ruby")

  solution_filename = "#{year}/day#{day.to_s.rjust(2, "0")}/ruby/solution.rb"
  system("cp utils/ruby/_template.rb #{solution_filename}")
  system("sed -i '' 's/___YEAR___/#{year}/g' #{solution_filename}")
  system("sed -i '' 's/___DAY___/#{day}/g' #{solution_filename}")
end
