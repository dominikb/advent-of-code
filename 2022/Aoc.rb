require 'net/http'
require 'tmpdir'

module Aoc
  def get_input(year:, day:, ignore_cache: false)
    if (not ignore_cache) && cache_exists?(year, day)
      return read_cache(year, day)
    end
    aoc_session = File.read('AOC_SESSION.txt').strip

    uri = URI("https://adventofcode.com/#{year}/day/#{day}/input")
    req = Net::HTTP::Get.new(uri)
    req['Cookie'] = "session=#{aoc_session}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    write_cache(year, day, response.body)
    read_cache(year, day)
  end

  def cache_exists?(year, day)
    File.exist?(cache_path(year, day))
  end

  def read_cache(year, day)
    File.readlines(cache_path(year, day)).map(&:strip)
  end

  def write_cache(year, day, input)
    File.write(cache_path(year, day), input)
  end

  def cache_path(year, day)
    "#{Dir.tmpdir}/aoc_input_#{year}_#{day}.txt"
  end
end
