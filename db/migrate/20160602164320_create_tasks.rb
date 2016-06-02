class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :image, index: true, foreign_key: true
      t.string :status
      t.string :params
      t.string :result

      t.timestamps null: false
    end
  end
end
