require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end  #should create a new instance given valid attributes
  
  describe "user associations" do
    
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end  #should have a user attribute
    
    it "should have teh right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end  #should have teh right associated user
    
  end # user associations
  
  describe "validations" do
    
    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end  #should require a user id
    
    it "should require non-blank content" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end  #should require non-blank content
    
    it "should reject long content" do
      long_post = "a" * 141
      @user.microposts.build(:content => long_post).should_not be_valid
    end  #should reject long content
    
  end # validations
  
  
end

# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

