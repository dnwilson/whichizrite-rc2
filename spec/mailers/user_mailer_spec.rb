require "spec_helper"

include Warden::Test::Helpers

describe UserMailer do
  before (:each) do
      @user = FactoryGirl.create(:user)
  end  
  
  describe "welcome mailer" do
  	let(:mail) { UserMailer.welcome(@user) }

  	it "should have the right subject" do
  		mail.subject.should == "Registered"
  	end

  	it "should have the right receiver email" do
  		mail.to.should == [@user.email]
  	end

  	it "should have the right sender email" do
  		mail.from.should == ['info@damagecontrolhq.com']
  	end

  	it "should have the user's correct name in the body" do
  		mail.body.encoded.should match(@user.name)  		
  	end
  end

  describe "profile update mailer" do
  	let(:mail) { UserMailer.profile_update(@user) }

  	it "should have the right subject" do
  		mail.subject.should == "Your profile was updated"
  	end

  	it "should have the right receiver email" do
  		mail.to.should == [@user.email]
  	end

  	it "should have the right sender email" do
  		mail.from.should == ['info@damagecontrolhq.com']
  	end

  	it "should have the user's correct name in the body" do
  		mail.body.encoded.should match(@user.name)  		
  	end
  end

  describe "follow alert mailer" do
  	let(:follower) { FactoryGirl.create(:user) }
  	let(:mail) { UserMailer.follow_alert(@user, follower) }

  	it "should have the right subject" do
  		mail.subject.should == "#{follower.username} is now following you!"
  	end

  	it "should have the right receiver email" do
  		mail.to.should == [@user.email]
  	end

  	it "should have the right sender email" do
  		mail.from.should == ['info@damagecontrolhq.com']
  	end

  	it "should have the user's correct name in the body" do
  		mail.body.encoded.should match(@user.name)  		
  	end

  	it "should have the followers's correct name in the body" do
  		mail.body.encoded.should match(follower.name)  		
  	end
  end

  describe "post commented mailer" do
  	let(:commenter) { FactoryGirl.create(:user) }
  	let(:post) { FactoryGirl.create(:post, user: @user) }
  	let(:comment) {user.comments.create(comment: "Lorem Ipsum", post_id: post.id)}
  	let(:mail) { UserMailer.post_comment(commenter, post) }

  	it "should have the right subject" do
  		mail.subject.should == "#{commenter.username} commented on your post"
  	end

  	it "should have the right receiver email" do
  		mail.to.should == [@user.email]
  	end

  	it "should have the right sender email" do
  		mail.from.should == ['info@damagecontrolhq.com']
  	end

  	it "should have the user's correct name in the body" do
  		mail.body.encoded.should match(@user.name)  		
  	end

  	it "should have the commenter's correct username in the body" do
  		mail.body.encoded.should match(commenter.username)  		
  	end

  	it "should have the post's title in the body" do
  		mail.body.encoded.should match(post.p_title)  		
  	end
  end

  describe "post voted mailer" do
  	let(:voter) { FactoryGirl.create(:user) }
  	let(:post) { FactoryGirl.create(:post, user: @user) }
  	let(:mail) { UserMailer.post_vote(voter, post) }

  	it "should have the right subject" do
  		mail.subject.should == "#{voter.username} voted on your post"
  	end

  	it "should have the right receiver email" do
  		mail.to.should == [@user.email]
  	end

  	it "should have the right sender email" do
  		mail.from.should == ['info@damagecontrolhq.com']
  	end

  	it "should have the user's correct name in the body" do
  		mail.body.encoded.should match(@user.name)  		
  	end

  	it "should have the voter's correct username in the body" do
  		mail.body.encoded.should match(voter.username)  		
  	end

  	it "should have the post's title in the body" do
  		mail.body.encoded.should match(post.p_title)  		
  	end
  end

  describe "comment voted mailer" do
  	let(:voter) { FactoryGirl.create(:user) }
  	let(:post) { FactoryGirl.create(:post, user: @user) }
  	let(:comment) {@user.comments.create(comment: "Lorem Ipsum", post_id: post.id)}
  	let(:mail) { UserMailer.comment_vote(voter, comment) }

  	it "should have the right subject" do
  		mail.subject.should == "#{voter.username} voted on your comment"
  	end

  	it "should have the right receiver email" do
  		mail.to.should == [@user.email]
  	end

  	it "should have the right sender email" do
  		mail.from.should == ['info@damagecontrolhq.com']
  	end

  	it "should have the user's correct name in the body" do
  		mail.body.encoded.should match(@user.name)  		
  	end

  	it "should have the commenter's correct username in the body" do
  		mail.body.encoded.should match(voter.username)  		
  	end

  	it "should have the post's title in the body" do
  		mail.body.encoded.should match(post.p_title)  		
  	end
  end
end
