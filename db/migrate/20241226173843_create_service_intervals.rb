class CreateServiceIntervals < ActiveRecord::Migration[7.2]
  def change
    create_table :service_intervals do |t|
      t.references :bike, null: false, foreign_key: true
      t.string :name
      t.integer :threshold_hours
      t.integer :threshold_months
      t.integer :threshold_km

      t.timestamps
    end
  end
end
