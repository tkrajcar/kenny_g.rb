require "midi"
require "json"

unless ARGV[0]
  puts "usage: ruby record_pattern.rb <numerical offset>"
  exit 0
end

offset = ARGV[0]
puts "Prepare to record a one-measure pattern in the key of C at 90bpm, transitioning #{offset} half steps."


@input = UniMIDI::Input.gets
@output = UniMIDI::Output.use(:first)

starting_time = nil # Will be set after the first note is recorded.

MIDI.using(@input, @output) do
  @all_notes = []
  @current_notes = {}
  at_exit do
    @output = File.open("patterns/#{offset}.json", "w")
    @output.write @all_notes.to_json
  end
  receive(:note_on, :note_off) do |note|
    if note.velocity == 0
      mynote = @current_notes.delete note.note
      mynote[:duration] = Time.now - mynote[:starting_time]
      mynote.delete :starting_time
      @all_notes << mynote
      puts "Ended #{mynote[:note]} (start #{mynote[:starting_time_offset]}, duration #{mynote[:duration]})"
    else
      starting_time = Time.now if starting_time.nil?
      @current_notes[note.note] = {note: note.note, velocity: note.velocity, starting_time: Time.now, starting_time_offset: Time.now - starting_time}
      puts "#{note.verbose_name} (note #{note.note} velocity #{note.velocity}) at #{Time.now - starting_time}"
    end
  end

  join
end
