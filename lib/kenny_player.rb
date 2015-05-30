require "midi"

class KennyPlayer
  attr_reader :key, :key_offset

  def initialize(key)
    @key = key
    @key_offset = %w{C C# D D# E F F# G G# A A# B}.find_index(key)
    puts "KENNY: Initialized in the key of #{@key} (#{@key_offset} half-steps from C)."
  end

  def play_sequence(starting_note, interval)
    puts "KENNY: Playing a sequence starting at #{starting_note} transitioning to #{interval}."
  end
end
