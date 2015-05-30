require "midi"

# prompt the user to select an input and output

@input = UniMIDI::Input.use(:first)
@output = UniMIDI::Output.use(:first)

MIDI.using(@output) do
  velocity 64

  (10..88).each do |n|
    play n, 0.01
  end
end
