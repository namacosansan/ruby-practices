#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

FILE_TYPE_MAP = {
  0o040000 => 'd',
  0o100000 => '-',
  0o120000 => 'l',
  0o020000 => 'c',
  0o060000 => 'b',
  0o010000 => 'p',
  0o140000 => 's',
  0o160000 => 'w' 
}.freeze

PERMISSION_BITS = [
  [0o400, 'r'], [0o200, 'w'], [0o100, 'x'],
  [0o040, 'r'], [0o020, 'w'], [0o010, 'x'],
  [0o004, 'r'], [0o002, 'w'], [0o001, 'x']
].freeze

SPECIAL_BITS = {
  0o4000 => [2, 's', 'S'],
  0o2000 => [5, 's', 'S'],
  0o1000 => [8, 't', 'T']
}.freeze

options = ARGV.getopts('a', 'r', 'l')
COL_SIZE = 3

def fetch_files(options)
  files = fetch_file_list(options)
  arrange_files(files)
end

def fetch_file_list(options)
  if options['a']
    Dir.entries('.')
  elsif options['r']
    Dir.glob('*').reverse
  elsif options['l']
    l_option
    exit
  else
    Dir.glob('*')
  end
end

def arrange_files(files)
  slice_size = calculate_slice_size(files)
  slices = create_slices(files, slice_size)
  transposed = transpose_slices(slices)
  max_length = max_file_length(files)
  padding_and_output(transposed, max_length)
end

def calculate_slice_size(files)
  (files.size / COL_SIZE.to_f).ceil
end

def create_slices(files, slice_size)
  slices = files.each_slice(slice_size).to_a
  max_length = slices.map(&:length).max
  slices.each { |slice| slice.fill(nil, slice.length...max_length) }
  slices
end

def transpose_slices(slices)
  slices.transpose
end

def max_file_length(files)
  files.map { |file| display_length(file) }.max
end

def display_length(str)
  str.chars.sum { |char| char.bytesize > 1 ? 2 : 1 }
end

def padding_and_output(transposed, max_length)
  transposed.each do |row|
    puts row.map { |file| file.to_s.ljust(max_length) }.join(' ')
  end
end

def l_option
  files = Dir.glob('*')
  l_option_total_blocks(files)
  l_option_file_details(files)
end

def l_option_total_blocks(files)
  puts(files.sum { |file| File.stat(file).blocks })
end

def l_option_file_details(files)
  l_option_max_lengths = l_option_max_lengths_hash(files)

  files.each do |file|
    stat = File.lstat(file)
    puts l_option_format_file_details(stat, l_option_max_lengths, file)
  end
end

def l_option_max_lengths_hash(files)
  {
    link: l_option_max_length(files) { |file| File.stat(file).nlink.to_s.length },
    owner: l_option_max_length(files) { |file| Etc.getpwuid(File.stat(file).uid).name.length },
    group: l_option_max_length(files) { |file| Etc.getgrgid(File.stat(file).gid).name.length },
    size: l_option_max_length(files) { |file| File.stat(file).size.to_s.length },
    mtime: l_option_max_length(files) { |file| File.stat(file).mtime.strftime('%b %d %H:%M').length }
  }
end

def l_option_max_length(files, &block)
  files.map(&block).max
end

def l_option_format_file_details(stat, l_option_max_lengths, file)
  permission = l_option_format_permissions(stat)
  details = l_option_file_hash(stat, l_option_max_lengths)

  "#{permission}  #{details[:link_count]} #{details[:owner_name]} " \
  "#{details[:group_name]} #{details[:file_size]} #{details[:mtime]} #{file}"
end

def l_option_format_permissions(stat)
  l_option_file_type(stat) + l_option_special_permissions(l_option_permission_bits(stat), stat)
end

def l_option_file_type(stat)
  FILE_TYPE_MAP[stat.mode & 0o170000] || '?'
end

def l_option_permission_bits(stat)
  PERMISSION_BITS.map { |bitmask, char| (stat.mode & bitmask).zero? ? '-' : char }.join
end

def l_option_special_permissions(perms, stat)
  SPECIAL_BITS.each do |bitmask, (index, exec_char, no_exec_char)|
    perms[index] = if (stat.mode & bitmask).zero?
                     perms[index]
                   else
                     perms[index] == 'x' ? exec_char : no_exec_char
                   end
  end
  perms
end

def l_option_file_hash(stat, l_option_max_lengths)
  {
    link_count: stat.nlink.to_s.rjust(l_option_max_lengths[:link]),
    owner_name: Etc.getpwuid(stat.uid).name.ljust(l_option_max_lengths[:owner]),
    group_name: Etc.getgrgid(stat.gid).name.ljust(l_option_max_lengths[:group]),
    file_size: stat.size.to_s.rjust(l_option_max_lengths[:size]),
    mtime: stat.mtime.strftime('%b %d %H:%M').ljust(l_option_max_lengths[:mtime])
  }
end

fetch_files(options)
