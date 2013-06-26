class AddPaperclipToAsset < ActiveRecord::Migration
  def self.up
    add_attachment :assets, :image
  end

  def self.down
    remove_attachment :assets, :image
  end
end
