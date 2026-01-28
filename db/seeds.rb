# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

words = File.readlines('db/answers.txt').map(&:chomp).shuffle

start_date = Date.new(2026, 1, 28)

words.each_with_index do |word, index|
  Puzzle.create!(
    answer: word,
    day: start_date + index.days
  )
end

puts "Created #{words.count} puzzles starting from #{start_date}"
