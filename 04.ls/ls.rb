#!/usr/bin/env ruby
# frozen_string_literal: true

COL_SIZE = 3

def fetch_files
  Dir.glob('*')
end

def calculate_slice_size(files)
  (files.size / COL_SIZE.to_f).ceil
end

def create_slices(files, slice_size)
  slices = files.each_slice(slice_size).to_a
  max_length = slices.map(&:length).max
  slices.each { |slice| slice.fill(nil, slice.length...max_length) }
end

def transpose_slices(slices)
  slices.transpose
end

def output(transposed)
  transposed.each do |row|
    puts row.map { |element| element || '' }.join("\t")
  end
end

files = fetch_files
slice_size = calculate_slice_size(files)
slices = create_slices(files, slice_size)
transposed = transpose_slices(slices)
output(transposed)
