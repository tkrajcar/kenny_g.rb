require "midi"

@output = UniMIDI::Output.use(:first)

MIDI.using(@output) do
  BPM = 1100
  PLAY_FOR = 0.02

  while true do
    play 80, PLAY_FOR
    sleep (60.0 / BPM) - PLAY_FOR
  end
end
