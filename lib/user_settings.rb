class ActiveRecord::Base
  def self.has_settings_on(*args)
    include RailsSettings::Extend
    args.each do |setting_name|
      # attr_accessible setting_name
      # settings_params
      define_method(setting_name)       { self.settings.send(setting_name) }
      define_method("#{setting_name}=") { |value| self.settings.send("#{setting_name}=", value) }
    end
  end

  def settings_params
  	params.require(:user).permit(:hide_profile, :fb_pub_comment, :fb_pub_post, :fb_pub_vote)
  end
end