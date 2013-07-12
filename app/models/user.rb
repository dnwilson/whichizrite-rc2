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
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :name, :password, :password_confirmation, :remember_me, :login,
                  :about_me, :dob, :avatar, :location, :country_name, :sex
  
  attr_accessor :login

  has_many :posts, dependent: :destroy
  has_many :comments

  acts_as_voter

  acts_as_follower
  acts_as_followable_plus

  has_attached_file :avatar, styles: {thumb: "30x30#", small: "100x100#", 
                                    med:"350x350#", large:"500x500>"},
                  default_url: "/assets/no-image.png",
                  url:  "/assets/images/users/:id/album/:style/:basename.:extension",
                  path: ":rails_root/public/assets/images/users/:id/album/:style/:basename.:extension"

  validates_attachment :avatar, content_type: {content_type: ["image/jpeg", "image/png", 
                                                        "image/bmp", "image/jpg"]},
                                size: {less_than: 5.megabytes}


  def feed
    Post.all
  end

  
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
