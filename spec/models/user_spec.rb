require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example user", :email => "user@example.com" }
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
  
  
  
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

