# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
scores.each do |s|
  if shots.length < 18
    if s == 'X'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  else
    shots << if s == 'X'
               10
             else
               s.to_i
             end
  end
end

frames = []
shots[0..17].each_slice(2) do |s|
  frames << s
end
shots[18..21].each_slice(1) do |s|
  frames << s
end

point = 0
frames.each_with_index do |current_frame, index|
  point += if index < 9
             if current_frame[0] == 10
               if frames[index + 1][0] == 10
                 10 + 10 + frames[index + 2][0]
               elsif frames[index + 1].length == 1
                 10 + frames[index + 1][0] + frames[index + 2][0]
               else
                 10 + frames[index + 1].sum
               end
             elsif current_frame.sum == 10
               10 + frames[index + 1][0]
             else
               current_frame.sum
             end
           else
             current_frame.sum
           end
end

puts "スコア合計: #{point}"
