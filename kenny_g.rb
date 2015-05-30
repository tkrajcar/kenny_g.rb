require "rubygems"
require "bundler/setup"
require "./lib/kenny_player"

puts File.read("splash.txt")

chords = fetch_and_validate_chords

puts "OK, let's see what we can do with #{chords}..."

offsets = convert_chords_to_offsets(chords)

puts "In offsets, that would be #{offsets}."

phrases = offsets_to_phrases(offsets)

puts "So, the phrases are #{phrases}."

kenny = KennyPlayer.new(chords[0])

phrases.each do |phrase|
  kenny.play_sequence(phrase[:starting_note], phrase[:interval])
end

BEGIN {
  def fetch_and_validate_chords
    chords = ""
    until validate_chords(chords) do
      print "> "
      chords = gets.chomp.upcase
    end
    chords
  end

  def validate_chords(chords)
    chords_array = chords.split(" ")
    return false if chords_array.length != 4
    chords_array.each do |chord|
      return false unless ("A".."G").include? chord
    end
    true
  end

  def convert_chords_to_offsets(chords)
    chords_array = chords.split(" ")

    the_notes = %w{C C# D D# E F F# G G# A A# B}
    lots_of_notes = the_notes * 2

    # Remove items off the beginning of lots_of_notes until we get to our first chord.
    lots_of_notes.delete_if do |note|
      break if note == chords[0]
      true
    end

    chords_array.collect { |chord| lots_of_notes.find_index(chord) }
  end

  def offsets_to_phrases(offsets)
    phrases = []
    offsets.each_with_index do |item, index|
      phrases << { starting_note: item, interval: offsets[index + 1] - item } unless index >= offsets.length - 1
    end
    phrases
  end
}