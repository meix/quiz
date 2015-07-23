class CreateTrainScores < ActiveRecord::Migration
  def change
    create_table :train_scores do |t|
      t.integer  :user_id, null: false
      t.integer  :diamond, default: 0
      t.integer  :right_times, default: 0
      t.decimal  :ratio, precision: 3, scale: 2, default: 0
      t.datetime :end_at
      t.integer  :spend, default: 0
      t.timestamps
    end
     add_index :train_scores, :user_id, unique: true
  end
end
