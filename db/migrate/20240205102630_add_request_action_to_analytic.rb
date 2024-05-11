class AddRequestActionToAnalytic < ActiveRecord::Migration[7.0]
  def change
    add_column :analytics, :controller, :string
    add_column :analytics, :action_name, :string
  end
end
