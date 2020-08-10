require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_letters
  end

  def score
    @results = ""
    word = params[:word]
    # letters = params[:letters]
    letters = "apple"
    english_word = check_word_api(word)
    in_the_grid = grid_included?(word, letters)
    letters_overusage = overused_letters?(word, letters)
    if !in_the_grid
      @results ="This word cannot be built out of the grid "
    elsif in_the_grid && !english_word
      @results = "Not a Valid english word"
    elsif english_word && in_the_grid && !letters_overusage
      @results = "Congratulations"
    end
    @results
  end

  def check_word_api(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized = open(url).read
    check_result = JSON.parse(serialized)
    check_result["found"] ? true : false
  end

  def grid_included?(word, letters)
    word_letters = word.split("")
    check_result = true
    word_letters.each do |letter|
      check_result = false unless letters.include?(letter)
    end
    check_result
  end

  def overused_letters?(word, letters)
    word_letters = word.split("")
    check_result = false
    word_letters.each do |letter|
      check_result = true if word.count(letter) > letters.count(letter)
    end
    check_result
  end

  def generate_letters
    array = ('A'..'Z').to_a
    letters = ""
    10.times do
      letters << array[rand(array.size - 1)]
    end
    letters
  end

  def calculate_points

  end
  protect_from_forgery with: :null_session
end
