class RemoveOptionsFromQuestion < ActiveRecord::Migration
  def up
    change_table :questions do |t|
      t.remove :options
    end
  end

  def down
    change_table :questions do |t|
      t.text :options
    end
  end
end
