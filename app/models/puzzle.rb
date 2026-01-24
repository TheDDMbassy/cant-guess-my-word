# == Schema Information
#
# Table name: puzzles
#
#  id         :integer          not null, primary key
#  day        :date
#  answer     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Puzzle < ApplicationRecord
end
