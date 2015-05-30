require "midi"
require "json"

# prompt the user to select an input and output
@input = UniMIDI::Input.gets
@output = UniMIDI::Output.use(:first)
starting_time = Time.now
MIDI.using(@input, @output) do
  @all_notes = []
  @current_notes = {}
  at_exit do
    @output = File.open("output.json", "w")
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
      @current_notes[note.note] = {note: note.note, velocity: note.velocity, starting_time: Time.now, starting_time_offset: Time.now - starting_time}
      puts "#{note.verbose_name} (note #{note.note} velocity #{note.velocity}) at #{Time.now - starting_time}"
    end
  end

  join
end
