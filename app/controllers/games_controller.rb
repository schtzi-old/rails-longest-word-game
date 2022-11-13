require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
    session[:score] = 0 unless session[:score]
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters].split('')
    dict = check_dictionary(@answer)
    grid = check_letters(@letters, @answer)
    @result = calc_result(grid, dict)
    @score = calc_score(dict)
  end

  private

  def calc_score(dict)
    session[:score] += dict['length'].to_i unless dict['length']
    session[:score]
  end

  def calc_result(grid, dict)
    if grid && dict['found']
      "Congratulations! \"#{@answer}\" is a valid answer."
    elsif !dict['found']
      "Sorry, it seems \"#{@answer}\" is no english word!"
    else
      "Sorry, but you can't build \"#{@answer}\" from \"#{@letters.each{ |letter| p letter}}\”"
    end
  end

  def check_dictionary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    JSON.parse(URI.open(url).read)
  end

  def check_letters(letter_array, word)
    word.split('').each do |char|
      return false unless letter_array.include?(char)

      letter_array[letter_array.find_index(char)] = ''
    end
    true
  end
end
