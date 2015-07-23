class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nick_name, null: false
      t.string :email
      t.integer :age
      t.integer :sex, default: 1
      t.string :avatar

      t.timestamps
    end
     add_index :users, :nick_name
  end
end
