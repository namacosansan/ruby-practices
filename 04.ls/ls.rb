#!/usr/bin/env ruby
# frozen_string_literal: true

def fetch_files
  Dir.glob('*')
end

def calculate_slice_size(files)
  (files.size / 3.0).ceil
end

def create_slices(files, slice_size)
  slices = files.each_slice(slice_size).to_a
  max_length = slices.map(&:length).max
  slices.each { |slice| slice.fill(nil, slice.length...max_length) }
end

def transpose_slices(slices)
  slices.transpose
end

def flatten_and_clean(transposed)
  transposed.flatten
end

def max_file_length(files)
  files.map { |file| display_length(file) }.max
end

def display_length(str)
  return 0 if str.nil?

  str.chars.sum { |char| char.bytesize > 1 ? 2 : 1 }
end

def format_and_print_files(files, max_length)
  files.each_slice(3) do |group|
    puts group.map { |file|
      next '' if file.nil?

      padding = max_length - display_length(file) + file.length
      file.ljust(padding)
    }.join(' ')
  end
end

files = fetch_files
slice_size = calculate_slice_size(files)
slices = create_slices(files, slice_size)
transposed = transpose_slices(slices)
flattened = flatten_and_clean(transposed)
max_length = max_file_length(flattened)
format_and_print_files(flattened, max_length).compact
