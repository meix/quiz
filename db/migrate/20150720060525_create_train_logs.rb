class CreateTrainLogs < ActiveRecord::Migration
  def change
    create_table :train_logs do |t|
      t.integer  :user_id, null: false
      t.integer  :question_id, null: false
      t.integer  :total_times, default: 0
      t.integer  :right_times, default: 0
      t.integer  :diamond, default: 0

      t.timestamps
    end
    add_index :train_logs, [:user_id, :question_id], unique: true
  end
end
