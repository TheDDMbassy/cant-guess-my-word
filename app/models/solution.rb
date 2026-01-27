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
  include AASM

  aasm column: :status do
    state :no_guesses, initial: true
    state :guessing
    state :gave_up
    state :solved, before_enter: :solve

    event :guess, after: :add_guess_to_guesses_list, guards: [ :allowed? ] do
      before do |word|
        log("STATE MACHINE EVENT `guess` fired with word '#{word}'")
      end

      after do |word|
        log("STATE MACHINE EVENT `guess` complete, status is now #{status}")
      end

      transitions from: :guessing, to: :solved, guard: :right_answer?
      transitions from: :no_guesses, to: :solved, guard: :right_answer?

      transitions from: :no_guesses, to: :guessing
      transitions from: :guessing, to: :guessing
    end

    event :give_up do
      transitions from: :guessing, to: :gave_up
    end
  end

  def solve
    self.update!(elapsed_time: Time.now - start_time)
  end

  def allowed?(word)
    log("checking if '#{word}' is `allowed?`")

    unless DICTIONARY.include?(word.downcase)
      log("nope, it's not in the dictionary")
      if errors[:most_recent_guess].count < 1
        errors.add(:most_recent_guess, "Guess must be an English word. (Scrabble-acceptable)")
      end
      return false
    end

    guess_list = guesses&.split&.sort || []
    if guess_list.include?(word)
      log("nope, already guessed it")
      if errors[:most_recent_guess].count < 1
        errors.add(:most_recent_guess, "Oops, you've already guessed that word.")
      end
      return false
    end

    log("yep, it's allowed!")
    true
  end

  def add_guess_to_guesses_list(word)
    self.update!(guesses: "#{guesses} #{word}".strip, most_recent_guess: word).tap do
      log "STATE MACHINE AFTER TRANSITION updated guess list with '#{word}', list is now '#{guesses}'"
    end
  end

  def right_answer?(word)
    word == answer
  end

  def start_time
    created_at || Time.now
  end

  def log(thing)
    Rails.logger.info("===> #{thing}")
  end

  # View Helpers, extract later

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

  def guess_stats
    "(#{guess_count} guesses in #{format_elapsed_time})"
  end

  def format_elapsed_time
    quotient, remainder = elapsed_time.divmod(60)

    time = "#{remainder}s"

    if quotient > 0
      time = "#{quotient}m and #{time}"
    end

    time
  end

  def guess_count
    sorted_guesses.count
  end
end
