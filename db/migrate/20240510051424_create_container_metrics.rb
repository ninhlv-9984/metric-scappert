class CreateContainerMetrics < ActiveRecord::Migration[7.0]
  def change
    create_table :container_metrics do |t|
      t.string :name
      t.float :cpu_millicores
      t.float :memory_mb
      t.string :namespace, index: true

      t.timestamps
    end
  end
end
