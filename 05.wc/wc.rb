#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l', 'w', 'c')

def main(options)
  if !$stdin.tty? # パイプがある場合
    pipe_input(options)
  elsif !ARGV.empty? # 引数がある場合
    file_input(options)
  else # 引数もパイプもない場合
    keyboard_input(options)
  end
end

def pipe_input(options)
  input = $stdin.read
  count_and_output(input, options)
end

def file_input(options)
  ARGV.each do |filename|
    input = File.read(filename)
    count_and_output(input, options, filename)
  end
end

def keyboard_input(options)
  input = +""
  while line = gets
    input << line
  end
  count_and_output(input, options)
end

def count_and_output(input, options, filename = nil)
  lines = input.lines.count
  words = input.split(/\s+/).reject(&:empty?).count
  bytes = input.bytesize

  results = []
  results << lines if options["l"]
  results << words if options["w"]
  results << bytes if options["c"]

  if results.empty?
    # オプション無しなら全部出す
    results = [lines, words, bytes]
  end

  print results.join("\t")
  print "\t#{filename}" if filename
  puts
end

main(options)
=begin
require 'minitest/autorun'

class Test < Minitest::Test

  def test_standard_input
    assert_equal 'hello', keyboard_input(hello)
    #assert_equal '2', fizz_buzz(2)
    #assert_equal 'Fizz', fizz_buzz(3)
    #assert_equal '4', fizz_buzz(4)
    #assert_equal 'Buzz', fizz_buzz(5)
    #assert_equal 'Fizz', fizz_buzz(6)
    #assert_equal 'Fizz Buzz', fizz_buzz(15)
  end
end
=end