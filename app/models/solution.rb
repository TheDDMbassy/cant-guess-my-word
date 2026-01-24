# == Schema Information
#
# Table name: solutions
#
#  id                :integer          not null, primary key
#  status            :string
#  guesser_name      :string
#  elapsed_time      :integer
#  most_recent_guess :string
#  guesses           :text
#  puzzle_id         :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_solutions_on_puzzle_id  (puzzle_id)
#

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
