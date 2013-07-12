class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :country_name, :string
  	add_column :users, :location, :string
  	add_column :users, :provider, :string
  	add_column :users, :uid, :string
  	add_column :users, :private_followable, :boolean, :default => false
  end
end
