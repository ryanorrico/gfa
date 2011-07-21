require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name                  => "Example user", 
              :email                 => "user@example.com",
              :password              => "foobar",
              :password_confirmation => "foobar" 
            }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end  #should create a new instance given valid attributes
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => " "))
    no_name_user.should_not be_valid
  end  #should require a name

  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => " "))
    no_email_user.should_not be_valid
  end  #should require an email
  
  it "should not allow a long name" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end  #should not allow a long name
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.com first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end  
  end  #should accept valid email addresses

  it "should reject invalid email addresses" do
    addresses= %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end  #should reject invalid email addresse
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    duplicate_email_user = User.new(@attr)
    duplicate_email_user.should_not be_valid
  end  #should reject duplicate email addresses

  it "should reject duplicate email addresses up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid    
  end  #should reject duplicate email addresses up to case
  
  describe "password validations" do
      
      it "should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
      end  #should require a password
  
      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
      end  #should require a matching password confirmation
  
      it "should reject short passwords" do
        shortpass = "a" * 5
        hash = @attr.merge(:password => shortpass, :password_confirmation => shortpass)
        User.new(hash).should_not be_valid
      end  #should reject short passwords
  
      it "should reject long passwords" do
        longpass = "a" * 41
        hash = @attr.merge(:password => longpass, :password_confirmation => longpass)
        User.new(hash).should_not be_valid
      end  #should reject long passwords
  end # password validations
  
  
  describe "password encryptions" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end  #should have an encrypted password attribute
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end  #should set the encrypted password

    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end  #should be true if the passwords match
      
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end  #should be false if the passwords don't match
      
    end # has_password? method
    
    describe "authenticate method" do
      
        it "should return nil on email/password mismatch" do
          wrong_password_user = User.authenticate(@attr[:email], "wrong pass")
          wrong_password_user.should be_nil
        end  #should return nil on email/password mismatch
        
        it "should return nil for an email with no user" do
          nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
          nonexistent_user.should be_nil
        end  #should return nil for an email with no user
        
        it "should return the user on email/password match" do
          matching_user = User.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end  #should return the user on email/password match
        
    end # authenticate method

  end # password encryptions
  
  
  describe "admin attribute" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end  #should respond to admin
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end  #should not be an admin by default
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end  #should be convertible to an admin
  
  end # admin attribute
  
  describe "micropost associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end  #should have a microposts attribute
    
    it "should have the microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end  #should have the microposts in the right order
    
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1,@mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end  #should destroy associated microposts
    
    describe "status feed" do
      
      it "should have a feed" do
        @user.should respond_to(:feed)
      end  #should have a feed
      
      it "should include the user's microposts" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end  #should include the user's microposts
    end # status feed
    
      it "should not include another user's microposts" do
        mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
      end  #should not include another user's microposts
      
  end # micropost associations

end





# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

