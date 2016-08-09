class AddColumnsToToken < ActiveRecord::Migration
  def change
    add_column :tokens, :email, :string
    add_column :tokens, :name, :string
  end
end
