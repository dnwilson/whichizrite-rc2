class Post < ActiveRecord::Base
  include AutoHtml
  include PgSearch
  extend FriendlyId
  friendly_id :p_title, use: [:slugged]

  multisearchable :against => [:p_title, :p_body]

  # attr_accessible :p_title, :p_image, :anonymous_post, :p_body, :p_type, 
  #                 :p_body_html, :category_id, :tag_list, :p_media, :p_media_html

  has_attached_file :p_image, styles: {main: "250x250>", large: "600x600>", thumb: "125x125#"},
  							  url: "/assets/images/:id/:style/:basename.:extension",
  							  path: ":rails_root/public/assets/images/:id/:style/:basename.:extension"
  belongs_to :user
  belongs_to :category

  has_many :comments, dependent: :destroy

  has_many :taggings
  has_many :tags, through: :taggings

  after_create :categorize

  acts_as_voteable

  default_scope -> {order('created_at DESC')}

  VALID_WEBSITE_REGEX = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  validates_presence_of :user_id, message: "You need to enter a title for this story"
  validates :p_title, presence: true, length: {maximum: 30}
  validates :p_body, presence: true
  validates :category_id, presence: true
  validates :tag_list, presence: true
  # validates :p_media, format: {with: VALID_WEBSITE_REGEX}

  def has_attached_image?
    if self.p_image != nil or self.p_image_url != nil
    end
  end

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

  def self.cat_list(name)
    cat = Category.find_by_cat_name(name)
    where("category_id = #{cat.id}")
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

  def self.from_users_followed_by(user)
    followed_user_ids="SELECT followable_id FROM follows
                      WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR origin_user_id = :user_id",
      user_id: user.id)    
  end

  def self.posts_from_me(user)
    where("origin_user_id = :user_id", user_id: user.id)    
  end

  auto_html_for :p_body do
    html_escape
    image
    youtube(:width => 438, :height => 246)
    soundcloud(:maxwidth => '438')
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  auto_html_for :p_media do
    html_escape
    image
    youtube(:width => 438, :height => 246)
    soundcloud(:maxwidth => '438')
    worldstar(:width => 448, :height => 374)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  AutoHtml.add_filter(:worldstar).with(:width => 448, :height => 374) do |text,options|
    text.gsub(/http:\/\/www\.worldstarhiphop\.com\/videos\/video\.php\?v\=(wshh[A-Za-z0-9]+)/) do
      video_id = $1
      width  = options[:width]
      height = options[:height]
      %{<object width="448" height="374"><param name="movie" value="http://www.worldstarhiphop.com/videos/e/16711680/#{video_id}"><param name="allowFullScreen" value="true"></param><embed src="http://www.worldstarhiphop.com/videos/e/16711680/#{video_id}" type="application/x-shockwave-flash" allowFullscreen="true" width="448" height="374"></embed></object>}
    end
  end

  def categorize
    youtube_regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
    youtube_id = $3
    worldstar_regex = /http:\/\/www\.worldstarhiphop\.com\/videos\/video\.php\?v\=(wshh[A-Za-z0-9]+)/
    worldstar_id = $1
    if self.p_media == "" && self.p_image_url == "" && self.p_image_file_name == nil
      self.p_type = 'text'
      self.save
    else
      if self.p_media != ""
        if youtube_regex.match(self.p_media)
          youtube_regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
          youtube_id = $3
          self.p_type = 'video'
          link = 'http://img.youtube.com/vi/' + youtube_id + '/0.jpg'
          self.p_image = URI.parse(link).to_s
          self.save
        elsif worldstar_regex.match(self.p_media)
          link = Nokogiri::HTML(open(self.p_media)).css("meta[property='og:image']").first.attributes["content"]
          self.p_image = URI.parse(link).to_s
          self.p_type = 'video'
          self.save
        else
          self.p_type = 'image'
          text = self.p_media.to_s
          self.p_image = URI.parse(text).to_s
          self.save      
        end 
      elsif self.p_image_url != ""
          self.p_type = 'image'
          text = self.p_image_url.to_s
          self.p_image = URI.parse(text).to_s
          self.save
      else
          self.p_type = 'image'
          self.save 
      end
    end
  end

  def img_from_url(url)
    self.p_image = URI.parse(url).to_s    
  end
end
