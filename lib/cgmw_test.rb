require "minitest/autorun"
require "aasm"
require "debug"

class Puzzle
  attr_reader :answer
  def initialize(answer:)
    @answer = answer
  end
end

class Solution
  attr_reader :start_time, :guesses, :dictionary, :elapsed_time

  include AASM

  aasm do
    state :no_guesses, initial: true
    state :guessing
    state :solved, before_enter: :solve

    after_all_transitions :add_guess_to_guesses_list

    event :guess, guards: [:is_real_word?] do
      transitions from: :guessing, to: :solved, guard: :right_answer?
      transitions from: :no_guesses, to: :solved, guard: :right_answer?

      transitions from: :no_guesses, to: :guessing
      transitions from: :guessing, to: :guessing
    end
  end


  def initialize()
    @start_time = Time.now
    @elapsed_time = nil
    @answer = 'serendipity'
    @guesses = []
    @dictionary = ["apple", "banana", "cranberry", "durian", "eggplant", "fig", "serendipity"]
  end

  def solve
    @elapsed_time = Time.now - @start_time
  end

  def is_real_word?(word)
    dictionary.include?(word)
  end

  def add_guess_to_guesses_list(word)
    guesses << word
  end

  def right_answer?(word)
    word == @answer
  end
end

class SolutionTest < Minitest::Test
  def setup
    @sol = Solution.new
  end

  def test_guess__not_a_real_word
    assert_raises 'AASM::InvalidTransition' do
      @sol.guess("asdf")
    end
  end

  def test_guesses_recorded
    @sol.guess("banana")
    @sol.guess("apple")
    @sol.guess("durian")
    @sol.guess("serendipity")

    # Order matters
    assert_equal ["banana", "apple", "durian", "serendipity"], @sol.guesses
    assert @sol.solved?, "Expected puzzle to be solved"
    assert @sol.elapsed_time, "Expected elapsed time NOT to be `nil`"
  end

  def test_instant_correct_guess
    assert @sol.no_guesses?

    @sol.guess("serendipity")

    assert @sol.solved?, "Expected solution state to be solved"
  end

  def test_timing
    assert @sol.start_time, "Expected start time to not be nil"
    assert_nil @sol.elapsed_time, "Expected elapsed time to be `nil` for unsolved solution"
  end

  def test_elapsed_time
    @sol.solve
    assert @sol.elapsed_time, "Expected elapsed time NOT to be `nil`"
  end

  def test_initial_state
    assert @sol.no_guesses?
  end
end
