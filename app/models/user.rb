class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  include PgSearch
  include RailsSettings::Extend
  extend FriendlyId
  friendly_id :username, use: [:slugged]
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable

  before_create :set_username
  after_create  :store_settings

  multisearchable :against => [:name, :username, :email]

  # attr_accessible :username, :email, :name, :password, :password_confirmation, :remember_me, :login,
  #                 :aboutme, :dob, :avatar, :location, :country_name, :sex, :uid, :provider, :profilepic, 
  #                 :auth_token, :aboutme_html

  attr_accessor :login

  has_many    :posts, dependent: :destroy
  has_many    :comments

  acts_as_voter

  acts_as_follower_plus
  acts_as_followable_plus

  has_attached_file :avatar, styles: {thumb: "30x30#", small: "100x100#", 
                                    med:"350x350#", large:"500x500>"},
                  default_url: "/assets/default/:style/no-image.png",
                  url:  "/assets/images/users/:id/album/:style/:basename.:extension",
                  path: ":rails_root/public/assets/images/users/:id/album/:style/:basename.:extension"

  validates_attachment :avatar, content_type: {content_type: ["image/jpeg", "image/png", 
                                                        "image/bmp", "image/jpg", "image/gif"]},
                                size: {less_than: 5.megabytes}

  before_save{|user| user.email = email.downcase}

  VALID_EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  VALID_USERNAME_REGEX = /[a-zA-Z0-9_\.]/
  VALID_NAME_REGEX = /[\w\s\-]/
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive:false}
  validates :email, format: {with: VALID_EMAIL_REGEX}                             
  validates :password, presence: true, length: {minimum: 8, maximum: 25}, on: :create
  validates :password, length: {minimum: 8, maximum: 25}, on: :update, allow_blank: true

  has_settings_on :hide_profile, :fb_pub_comment, :fb_pub_post, :fb_pub_vote,
                  :email_post_comment, :email_comment_vote, :email_follow_alert,
                  :email_profile_update, :email_post_vote

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           username: auth.info.nickname,
                           email:auth.info.email,
                           sex: auth.extra.raw_info.gender,
                           password:Devise.friendly_token[0,20],
                           auth_token: auth.credentials.token
                           )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def feed
    Post.from_users_followed_by(self)
  end

  def myfeed
    Post.posts_from_me(self)
  end  
  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def facebook
    @fb_user ||= FbGraph::User.me(self.auth_token)
  end

  def fbconnect(story, title, url)    
    app = FbGraph::Application.new(FACEBOOK_CONFIG['app_id'])
    me = FbGraph::User.me(self.auth_token)

    ## Custom Action (you need to configure them in your app setting)

    # Fetch activities
    actions = me.og_actions app.og_action(story)

    # Publish an activity
    action = me.og_action!(
      app.og_action(story),
      :article => 'http://samples.ogp.me/434264856596891'
    )
  end

  def fbsignup    
    app = FbGraph::Application.new(FACEBOOK_CONFIG['app_id'])
    me = FbGraph::User.me(self.auth_token)

    ## Custom Action (you need to configure them in your app setting)

    # Fetch activities
    actions = me.og_actions app.og_action(:connect)

    # Publish an activity
    action = me.og_action!(
      app.og_action(:connect),
      :object => 'http://samples.ogp.me/434264856596891'
    )
  end

  def fb_publish(post_title, post_url)

    #Check if user is connected to facebook
    if self.provider == 'facebook'
      
      #Check if the user as any special settings
      if self.settings.all != nil
        
        #Define facebook action type
        if self.settings.fb_pub_post = '1'
          story = 'create'
        elsif self.settings.fb_pub_vote = '1'
          story = 'vote'
        else
          story = 'comment'
        end
        
      end

      #Publish comment
      self.fbconnect(story, post_title, post_url)
    end    
  end

  private 
    def set_username
      username = self.email[/^[^@]+/]
      if User.find_by_username(username) != nil
        self.username = "#{username}.#{User.last.id.to_s[0..3]}"
      else        
        self.username = "#{self.email[/^[^@]+/]}"
      end
    end

    def store_settings
      if self.provider == 'facebook'
        self.settings.hide_profile = '1' 
        self.settings.fb_pub_post = '1' 
        self.settings.fb_pub_vote = '1' 
        self.settings.fb_pub_comment = '1' 
        self.save
      else
        self.email_post_comment = '1' 
        self.email_comment_vote = '1' 
        self.email_follow_alert = '1'
        self.email_profile_update = '1' 
        self.email_post_vote = '1'
        self.save
      end
    end
end
