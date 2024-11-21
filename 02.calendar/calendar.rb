#!/usr/bin/env ruby

require 'optparse'
require 'date'

def calendar(year, month)
  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)
  today = Date.today

  puts  "     #{month}月 #{year}"
  puts "日 月 火 水 木 金 土"

  (first_day..last_day).each do |date|
    print "   " * date.wday if date == first_day

    if date.saturday? && date == today
      print "{\e[7m#{date.day.to_s.rjust(2)}\e[0m }\n"
    elsif  date.saturday? 
      print "#{date.day.to_s.rjust(2)}\n"
    elsif  date == today
      print "\e[7m#{date.day.to_s.rjust(2)}\e[0m "
    else
      print "#{date.day.to_s.rjust(2)} "
    end
  end
  print "\n" unless last_day.saturday? 
end

command = ARGV.getopts("y:m:")
year = command["y"] ? command["y"].to_i : Date.today.year
month = command["m"] ? command["m"].to_i : Date.today.month

calendar(year, month)