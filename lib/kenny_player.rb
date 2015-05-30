require "midi"
require "json"
require "pry"

class KennyPlayer
  attr_reader :key, :midi_output

  def initialize(key)
    @key = key
    @midi_output = UniMIDI::Output.use(:first)

    puts "KENNY: Initialized in the key of #{@key} (#{@key_offset} half-steps from C)."
  end

  def play_sequence(starting_note, interval)
    puts "KENNY: Playing a sequence starting at #{starting_note} transitioning to #{interval}."
    key_offset = %w{C C# D D# E F F# G G# A A# B}.find_index(@key)

    MIDI.using(@midi_output) do
      @notes = JSON.parse(File.read("patterns/#{interval}.json"))

      @messages = @notes.flat_map do |note|
        [
          {type: :note_on, note: note["note"] + starting_note + key_offset, velocity: note["velocity"], at: note["starting_time_offset"]},
          {type: :note_off, note: note["note"] + starting_note + key_offset, at: note["starting_time_offset"] + note["duration"]}
        ]
      end

      @messages.sort! do |a, b|
        a[:at] - b[:at]
      end

      @offset = 0

      @messages.each do |message|
        sleep_duration = message[:at] - @offset
        puts "KENNY: Sleeping for #{sleep_duration} to #{message[:at]}"
        sleep sleep_duration

        if message[:type] == :note_on
          puts "KENNY: Playing #{message[:note]} at velocity #{message[:velocity]}"
          note message[:note], velocity: message[:velocity]
        else
          note_off message[:note]
        end

        @offset += sleep_duration
      end
    end
  end
end
