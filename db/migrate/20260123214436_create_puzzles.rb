class CreatePuzzles < ActiveRecord::Migration[8.0]
  def change
    create_table :puzzles do |t|
      t.date :day
      t.string :answer

      t.timestamps
    end
  end
end
