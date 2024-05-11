class AddRequestVertToAnalytic < ActiveRecord::Migration[7.0]
  def change
    add_column :analytics, :request_verb, :string
  end
end
