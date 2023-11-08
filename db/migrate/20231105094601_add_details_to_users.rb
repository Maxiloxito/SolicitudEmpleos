class AddDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :experience, :integer
    add_column :users, :languages, :string
  end
end
