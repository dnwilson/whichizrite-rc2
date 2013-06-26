class Comment < ActiveRecord::Base
  attr_accessible :comment, :post_id, :user_id

  belongs_to :user
  belongs_to :post

  acts_as_voteable

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :comment, presence: true, length: {minimum: 1}

  def votecount
  	if self.votes_for == self.votes_against 
	   self.votes_for - self.votes_against
  	elsif self.votes_for > self.votes_against 
  	   self.votes_for - self.votes_against 
  	else
  	   self.votes_against - self.votes_for
  	end 
  end
  
end
