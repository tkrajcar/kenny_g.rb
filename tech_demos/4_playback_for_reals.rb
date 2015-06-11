require "midi"
require "json"

@output = UniMIDI::Output.use(:first)

MIDI.using(@output) do
  @notes = JSON.parse(File.read("output_good.json"))

  @messages = @notes.flat_map do |note|
    [
      {type: :note_on, note: note["note"], velocity: note["velocity"], at: note["starting_time_offset"]},
      {type: :note_off, note: note["note"], at: note["starting_time_offset"] + note["duration"]}
    ]
  end

  @messages.sort! do |a, b|
    a[:at] - b[:at]
  end

  @offset = 0

  @messages.each do |message|
    sleep_duration = message[:at] - @offset
    puts "sleeping for #{sleep_duration} to #{message[:at]}"
    sleep sleep_duration

    if message[:type] == :note_on
      note message[:note], velocity: message[:velocity]
    else
      note_off message[:note]
    end

    @offset += sleep_duration
  end
end
