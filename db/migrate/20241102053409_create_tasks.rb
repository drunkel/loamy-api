class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :body
      t.datetime :due_at
      t.datetime :archived_at
      t.timestamps
    end
  end
end
