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

require "test_helper"

class SolutionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
