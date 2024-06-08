#!/usr/bin/env ruby
require 'optparse'
require 'date'

def calendar(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
  today = Date.today

  puts  "     #{month}月 #{year}"
  puts "日 月 火 水 木 金 土"
  print "   " * first_day.wday

  (first_day..last_day).each do |date|
    day_str = date.day.to_s.rjust(2)
    if date == today
      day_str = "\e[7m#{day_str}\e[0m"
    end
    if date.saturday?
      puts day_str
    else
      print "#{day_str} "
    end
  end
  print "\n" unless last_day.saturday?
end

options = ARGV.getopts("y:m:")
year = (options["y"] || Date.today.year).to_i
month = (options["m"] || Date.today.month).to_i

calendar(year, month)
