# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  admin                  :boolean          default(FALSE)
#  username               :string(255)
#  name                   :string(255)
#  sex                    :string(255)
#  dob                    :string(255)
#  about_me               :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  country_name           :string(255)
#  location               :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  private_followable     :boolean          default(FALSE)
#  profilepic             :string(255)
#  auth_token             :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  include PgSearch
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable

  before_create :set_username

  multisearchable :against => [:name, :username, :email]


  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :name, :password, :password_confirmation, :remember_me, :login,
                  :about_me, :dob, :avatar, :location, :country_name, :sex, :uid, :provider, :profilepic, :auth_token
  
  attr_accessor :login

  has_many :posts, dependent: :destroy
  has_many :comments

  acts_as_voter

  acts_as_follower_plus
  acts_as_followable_plus

  has_attached_file :avatar, styles: {thumb: "30x30#", small: "100x100#", 
                                    med:"350x350#", large:"500x500>"},
                  default_url: "/assets/default/:style/no-image.png",
                  url:  "/assets/images/users/:id/album/:style/:basename.:extension",
                  path: ":rails_root/public/assets/images/users/:id/album/:style/:basename.:extension"

  validates_attachment :avatar, content_type: {content_type: ["image/jpeg", "image/png", 
                                                        "image/bmp", "image/jpg"]},
                                size: {less_than: 5.megabytes}

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

  def facebook
    @fb_user ||= FbGraph::User.me(self.auth_token)
  end

  def fbconnect    
    app = FbGraph::Application.new(413231458748257)
    me = FbGraph::User.me(self.auth_token)

    ## Custom Action (you need to configure them in your app setting)

    # Fetch activities
    actions = me.og_actions app.og_action(:connect)

    # Publish an activity
    action = me.og_action!(
      app.og_action(:connect), # or simply "APP_NAMESPACE:ACTION" as String
      :object => 'http://www.joystiq.com'
    )
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

  private 
    def set_username
      username = self.email[/^[^@]+/]
      if User.find_by_username(username) != nil
        self.username = "#{username}.#{User.last.id.to_s[0..3]}"
      else        
        self.username = "#{self.email[/^[^@]+/]}"
      end
    end
end
