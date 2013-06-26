class AddImageColumnToPost < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|

      t.has_attached_file :p_image

    end
  end

  def self.down

    drop_attached_file :posts, :p_image

  end
end
