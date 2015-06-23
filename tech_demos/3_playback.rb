require "midi"
require "json"

@output = UniMIDI::Output.use(:first)

MIDI.using(@output) do
  @notes = JSON.parse(File.read("sample.notejs"))
  @offset = 0

  @notes.each do |note|
    sleep_duration = note["starting_time_offset"] - @offset
    puts "sleeping #{sleep_duration} sec"
    sleep sleep_duration
    puts "playing note #{note["note"]} for #{note["duration"]}"
    play note["note"], note["duration"]
    @offset += note["duration"]
  end
end
