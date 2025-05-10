#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l', 'w', 'c')
def main(options)
  if !$stdin.tty?
    pipe_input(options)
  elsif !ARGV.empty?
    file_input(options)
  else
    keyboard_input(options)
  end
end

def pipe_input(options)
  input = $stdin.read
  results = line_and_words_and_bytes(input, options)
  output(results)
end

def file_input(options)
  all_results = []
  ARGV.each do |filename|
    input = File.read(filename)
    results = line_and_words_and_bytes(input, options, filename)
    output(results, filename)
    all_results << results
  end
  count_arguments(all_results)
end

def keyboard_input(options)
  input = +''
  while (line = gets)
    input << line
  end
  results = line_and_words_and_bytes(input, options)
  output(results)
end

def line_and_words_and_bytes(input, options, _filename = nil)
  lines = input.lines.count
  words = input.split(/\s+/).count
  bytes = input.bytesize

  results = []
  results << lines if options['l']
  results << words if options['w']
  results << bytes if options['c']

  results = [lines, words, bytes] if results.empty?
  results
end

def count_arguments(all_results)
  return unless ARGV.size >= 2

  sum_count(all_results)
end

def sum_count(all_results)
  sum = all_results.transpose.map(&:sum)
  output(sum, 'total')
  sum
end

def output(results, filename = nil)
  print results.map { |r| r.to_s.rjust(7) }.join("\t")
  print "\t#{filename}" if filename
  puts
end

main(options)
