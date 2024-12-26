class CreateBikes < ActiveRecord::Migration[7.2]
  def change
    create_table :bikes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :gear_id
      t.string :name
      t.date :last_service_date

      t.timestamps
    end

    add_index :bikes, :gear_id
  end
end
