class AddIndexToSolutionsStatus < ActiveRecord::Migration[8.0]
  def change
    add_index :solutions, :status
    add_index :solutions, :elapsed_time
  end
end
