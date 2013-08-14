# == Schema Information
#
# Table name: follows
#
#  id              :integer          not null, primary key
#  followable_id   :integer          not null
#  followable_type :string(255)      not null
#  follower_id     :integer          not null
#  follower_type   :string(255)      not null
#  blocked         :boolean          default(FALSE), not null
#  pending         :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Follow < ActiveRecord::Base

  extend ActsAsFollowerPlus::FollowerLib
  extend ActsAsFollowerPlus::FollowScopes

  # NOTE: Follows belong to the "followable" interface, and also to followers
  belongs_to :followable, :polymorphic => true
  belongs_to :follower,   :polymorphic => true

  def block!
    self.update_attribute(:blocked, true)
  end

end
