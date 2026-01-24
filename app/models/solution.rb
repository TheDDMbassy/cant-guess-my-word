class Solution < ApplicationRecord
  belongs_to :puzzle

  def answer
    @answer ||= puzzle.answer
  end

  def answer_is_after
    # for the upper half of the page
    sorted_guesses.select { |g| answer > g }
  end

  def answer_is_before
    # for the lower half of the page
    sorted_guesses.select { |g| answer < g }
  end

  def sorted_guesses
    @sorted_guesses ||= begin
      sorted = guesses.split.sort
    end
  end
end
