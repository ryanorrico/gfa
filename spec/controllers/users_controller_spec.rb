require 'spec_helper'

describe UsersController do

  render_views
  
  describe "GET 'show'" do
  
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end  #should be successful
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end  #should find the right user
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end  #should have the right title
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end  #should include the user's name
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end  #should have a profile image
    
  end # GET 'show'
  
  
  
  
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up")
    end  #should have the right title
  end

end
