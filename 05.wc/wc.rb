#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l', 'w', 'c')

def main(options)
  if options['l']
    l_option 
  elsif options['w']
    w_option 
  elsif options['c']
    c_option
  else
    no_option
  end
  
end


def l_option
  files = File.open("file1.txt", "r")
  l_option_count = files.read 
  puts l_option_count.count("\n")
end

def w_option

    files = File.open("1.txt", "r")

  puts files.read
end

def c_option
  files = File.open("2.txt", "r")
  puts files.read
end

def no_option
  files = File.open("file2.txt", "r")
  puts files.read
end

main(options)

#文字数をカウントする
#行数を数える
#単語数を数える
#バイト数を数える