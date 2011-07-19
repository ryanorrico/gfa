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
    
    describe "testing for fields" do
      
      it "should have a name field" do
        get :new
        response.should have_selector("input[name='user[name]'][type='text']")
      end  #should have a name field
      
      it "should have an email field" do
        get :new
        response.should have_selector("input[name='user[email]'][type='text']")
      end  #should have a email field
      
      it "should have a password field" do
        get :new
        response.should have_selector("input[name='user[password]'][type='password']")
      end  #should have a password field
      
      it "should have a password confirmation field" do
        get :new
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end  #should have a password confirmation field
      
    end # testing for fields
  end
  
  
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end  #should not create a user
  
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end  #should have the right title
      
      it "should render the the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end  #should render the the 'new' page
            
    end # failure
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", 
                  :password => "foobar", :password_confirmation => "foobar" }
      end
                  
        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end  #should create a user
        
        it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end  #should redirect to the user show page
        
        it "should display a welcome message" do
          post :create, :user => @attr
          flash[:success].should =~ /welcome to Get Fucking Awesome/i
        end  #should display a welcome message
        
    end # success
  end # POST 'create'
end
