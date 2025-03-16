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
  puts l_option_count.count("\n") + 1
end

def w_option
  files = File.open("1.txt", "r")
  w_option  = files.read
end

def c_option
  files = File.open("file1.txt", "r")
  c_option  = files.read
  puts c_option.bytesize
end

def no_option
  files = File.open("file2.txt", "r")
  puts files.read
end

def define_word
  #スペース（' '）、タブ（\t）、改行（\n）、キャリッジリターン（\r）を何個含むか
  #isspace()がtrueかどうか。数って数えられる？
  #isspace()がtrueのものが何個ある？
end

def count_line_breaks
  #改行（\n）を何個含むか
end

def bytesize_count

end



main(options)
