require_relative 'StringExtensions'
require_relative 'EnumerableExtensions'
require_relative 'RangeExtensions'

require 'net/http'
require 'tmpdir'

module Aoc
  def get_input(year:, day:, ignore_cache: false, strip: true)
    if (not ignore_cache) && cache_exists?(year, day)
      return read_cache(year, day, strip:)
    end
    aoc_session = File.read("#{__dir__}/../../AOC_SESSION.txt").strip

    uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
    req = Net::HTTP::Get.new(uri)
    req['Cookie'] = "session=#{aoc_session}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    write_cache(year, day, response.body)
    read_cache(year, day, strip:)
  end

  def cache_exists?(year, day)
    File.exist?(cache_path(year, day))
  end

  def read_cache(year, day, strip: true)
    File.readlines(cache_path(year, day)).map { strip ? _1.strip : _1 }
  end

  def write_cache(year, day, input)
    File.write(cache_path(year, day), input)
  end

  def cache_path(year, day)
    "#{year}/day#{day.to_s.rjust(2, '0')}/input.txt"
  end

  class << self
    include Aoc
  end
end