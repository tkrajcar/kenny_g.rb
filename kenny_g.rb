require "rubygems"
require "bundler/setup"
require "midi"

puts File.read("splash.txt")

chords = fetch_and_validate_chords

puts "OK, let's see what we can do with #{chords}..."

numbers = convert_chords_to_numbers(chords)

puts "In numerical notation, that would be #{numbers}."

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

  def convert_chords_to_numbers(chords)
    chords_array = chords.split(" ")
    root = chords_array.shift
    numbers = chords_array.collect do |chord|
      difference = chord.ord - root.ord
      difference < 0 ? difference + 8 : difference + 1
    end
    numbers.unshift 1 # always starts with the root
  end
}
