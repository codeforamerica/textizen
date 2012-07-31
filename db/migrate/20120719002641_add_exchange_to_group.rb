class AddExchangeToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :exchange, :string
  end
end
