#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l', 'w', 'c')

def main(options)
  if !$stdin.tty?
    process_stdin_input(options)
  elsif !ARGV.empty?
    process_files(options)
  else
    process_stdin_input(options)
  end
end

def process_stdin_input(options)
  input = $stdin.read
  results = line_and_words_and_bytes(input, options)
  output(results)
end

def process_files(options)
  all_results = []
  ARGV.each do |filename|
    input = File.read(filename)
    results = line_and_words_and_bytes(input, options, filename)
    output(results, filename)
    all_results << results
  end
  print_total(all_results) if ARGV.size >= 2
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

def print_total(all_results)
  sum = all_results.transpose.map(&:sum)
  output(sum, 'total')
end

def output(results, filename = nil)
  print results.map { |r| r.to_s.rjust(7) }.join("\t")
  print "\t#{filename}" if filename
  puts
end

main(options)
