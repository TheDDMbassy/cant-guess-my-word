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
#  index_solutions_on_elapsed_time  (elapsed_time)
#  index_solutions_on_puzzle_id     (puzzle_id)
#  index_solutions_on_status        (status)
#

require "test_helper"

class SolutionTest < ActiveSupport::TestCase
  def setup
    # Answer is "super"
    @solution = Solution.new(puzzle: puzzles(:one))
  end

  def test_initial_status
    assert_nil @solution.guesses
    assert @solution.no_guesses?
  end

  def test_guess__not_a_real_word
    assert_raises "AASM::InvalidTransition" do
      @solution.guess("asdf")
    end
  end

  def test_guesses_must_be_unique
    @solution.guess("apple")

    assert_raises "AASM::InvalidTransition" do
      @solution.guess("apple")
    end
  end

  def test_guesses_recorded
    @solution.guess("apple")
    @solution.guess("super")

    # Order matters
    assert_equal "apple super", @solution.guesses
    assert @solution.solved?, "Expected puzzle to be solved"
    assert @solution.elapsed_time, "Expected elapsed time NOT to be `nil`"
  end

  def test_instant_correct_guess
    assert @solution.no_guesses?
    @solution.save

    @solution.guess("super")

    assert @solution.solved?, "Expected solution state to be solved"
  end

  def test_elapsed_time
    assert_nil @solution.created_at

    @solution.save!

    assert @solution.created_at
    assert_nil @solution.elapsed_time

    @solution.solve
    assert @solution.elapsed_time, "Expected elapsed time NOT to be `nil`"
  end
end
