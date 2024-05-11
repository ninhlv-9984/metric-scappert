class CreateAnalytics < ActiveRecord::Migration[7.0]
  def change
    create_table :analytics do |t|
      t.string :school_name, index: true
      t.string :path
      t.integer :request_count

      t.timestamps
    end
  end
end
