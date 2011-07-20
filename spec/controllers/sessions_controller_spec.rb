require 'spec_helper'

describe SessionsController do

  render_views
  
  describe "GET 'new'" do
    
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end  #should have the right title
  
  end
  
  describe "POST 'create'" do
    
    describe "invalid sign in" do
      
      before(:each) do
        @attr = { :email => "ryan@example.com", :password => "invalid" }
      end
    
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end  #should re-render the new page
      
      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector('title', :content => "Sign in")        
      end  #should have the right title
      
      it "should display an error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end  #should display an error message
    
    end # invalid sign in
  
    describe "valid sign in" do
      
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end
      
      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end  #should sign the user in
      
      it "should redirect to the users show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end  #should redirect to the users show page
    end # valid sign in
    
  end # POST 'create'
  
  describe "DELETE 'destroy'" do
        
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end  #should sign a user out  

  end # DELETE 'destroy'

end
