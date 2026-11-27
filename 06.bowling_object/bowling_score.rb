# frozen_string_literal: true

class Shot
  def initialize(value)
    @value = value
  end

  attr_reader :value
end

class Frame
  def initialize(shots)
    @shots = shots
  end

  attr_reader :shots

  def self.from_input(input)
    values = input.split(',').map(&:strip)
    frame_values = []

    9.times do
      count = values.first == 'X' ? 1 : 2
      frame_values << values.shift(count)
    end
    frame_values << values

    frame_values.map do |group|
      shots = group.map { |value| Shot.new(value) }
      new(shots)
    end
  end

  def to_a
    shots.map(&:value)
  end
end

class Rule
  def self.strike?(shot)
    shot.value == 'X'
  end

  def self.spare?(first_pins, second_pins)
    first_pins + second_pins == 10
  end
end

class ScoreCalculator
  def initialize(frames)
    @frames = frames
  end

  def total_score
    first_nine_score + tenth_frame_score
  end

  def first_nine_score
    @frames.first(9).each_with_index.sum do |frame, index|
      pins = frame.shots.map { |shot| pins_for(shot) }
      pins.sum + bonus_for(frame, pins, index)
    end
  end

  def tenth_frame_score
    @frames.fetch(9).shots.sum { |shot| pins_for(shot) }
  end

  def bonus_for(frame, pins, index)
    next_shots = @frames.drop(index + 1).flat_map(&:shots)

    if Rule.strike?(frame.shots.first)
      next_shots.first(2).sum { |shot| pins_for(shot) }
    elsif Rule.spare?(pins[0], pins[1])
      pins_for(next_shots.first)
    else
      0
    end
  end

  def pins_for(shot)
    Rule.strike?(shot) ? 10 : shot.value.to_i
  end
end
