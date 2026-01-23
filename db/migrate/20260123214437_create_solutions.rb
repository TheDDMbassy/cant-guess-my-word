class CreateSolutions < ActiveRecord::Migration[8.0]
  def change
    create_table :solutions do |t|
      t.string :status
      t.string :guesser_name
      t.integer :elapsed_time
      t.string :most_recent_guess
      t.text :guesses
      t.references :puzzle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
