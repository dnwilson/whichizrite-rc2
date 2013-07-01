# == Schema Information
#
# Table name: posts
#
#  id             :integer          not null, primary key
#  p_type         :string(255)
#  p_title        :string(255)
#  p_body         :text
#  user_id        :integer
#  anonymous_post :boolean          default(FALSE)
#  p_category     :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Post < ActiveRecord::Base

  include AutoHtml
  include PgSearch

  multisearchable :against => [:p_title, :p_body]

  attr_accessible :p_title, :p_image, :anonymous_post, :p_body, :p_type, :cat_id, :user_id, :tag_list

  has_attached_file :p_image, styles: {main: "250x250>", large: "600x600>", thumb: "125x125#"},
  							  url: "/assets/images/:id/:style/:basename.:extension",
  							  path: ":rails_root/public/assets/images/:id/:style/:basename.:extension"
  belongs_to :user
  belongs_to :category

  has_many :comments, dependent: :destroy

  has_many :taggings
  has_many :tags, through: :taggings

  acts_as_voteable

  default_scope order: 'posts.created_at DESC'

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless Gallery.where(token: random_token).exists?
    end
  end

  def votecount
    if self.votes_for == self.votes_against 
     self.votes_for - self.votes_against
    elsif self.votes_for > self.votes_against 
       self.votes_for - self.votes_against 
    else
       self.votes_against - self.votes_for
    end 
  end

  def self.tagged_with(name)
  	Tag.find_by_name!(name).posts  	
  end

  def self.tag_counts
  	Tag.select("tags.*, count(taggings.tag_id) as count").
  		joins(:taggings).group("taggings.tag_id")
  end

  def tag_list
  	tags.map(&:name).join(", ")
  end

  def tag_list=(names)
  	self.tags = names.split(",").map do |n|
  		Tag.where(name: n.strip).first_or_create!
  	end
  end

  def self.featured_posts
    where("cat_id = 1")
  end
end
