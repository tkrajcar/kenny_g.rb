require "midi"

@output = UniMIDI::Output.use(:first)

MIDI.using(@output) do
  velocity 64
  (0..127).each do |n|
    play n, 0.01
  end
end
