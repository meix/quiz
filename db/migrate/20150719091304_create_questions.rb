class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :answer
      t.string :category
      t.integer :level
      t.string :explain
      t.integer :status, default: 0
      t.integer :quiz_type, default: 0

      t.timestamps
    end
  end
end
