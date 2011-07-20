require 'spec_helper'

describe UsersController do

  render_views
  
  describe "GET 'index'" do
    
    describe "for non-signed-in users" do
      
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end  #should deny access
      
    end # for non-signed-in users
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "bob@example.com")
        third = Factory(:user, :name => "Jerry", :email => "jerry@example.com")

        @users = [@user, second, third]
        
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end  #should be successful
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All users")
      end  #should have the right title
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end  #should have an element for each user
      
      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a",  :href => "/users?page=2",
                                            :content => "2")
        response.should have_selector("a",  :href => "/users?page=2",
                                            :content => "Next")
      end  #should paginate users
      
    end # for signed-in users
  
  end # GET 'index'
  
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
        
        it "should sign the user in" do
          post :create, :user => @attr
          controller.should be_signed_in
        end  #should sign the user in
        
    end # success
  end # POST 'create'
  
  describe "GET 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end  #should be successful
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit user")
    end  #should have the right title
    
    it "should have a link to change the gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector('a',  :href => gravatar_url,
                                          :content => "change")
    end  #should have a link to change the gravatar
    
  end # GET 'edit'
  
  
  
  describe "PUT 'update'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { :email => "", :name => "", :password => "", :password_confirmation => "" }
      end
      
      it "should render the edit page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end  #should render the edit page
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end  #should have the right title
    end # failure
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New name", :email => "user@example.org",
                  :password => "foobar", :password_confirmation => "foobar" }
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end  #should change the user's attributes
    
      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end  #should redirect to the user show page
    
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end  #should have a flash message
    
    end # success
    
  end # PUT 'update'
  
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end  #should deny access
    
    end # as a non-signed-in user
  
    describe "as a non-admin user" do
      
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end  #should protect the page
      
    end # as a non-admin user
  
    describe "as an admin user" do
      
      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end
        
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end  #should destroy the user
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end  #should redirect to the users page
      
      # it "should not allow an admin to destroy himself" do
      #   lambda do
      #     delete :destroy, :id => current_use
      #   end.should_not change(User, :count)
      # end  #should not allow an admin to destroy himself
      # 
    end # as an admin user
  end # DELETE 'destroy'
  
  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed in users" do
      
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)  
      end  #should deny access to 'edit'
      
      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end  #should deny access to 'update'
    
    end # for non-signed in users
    
    
    describe "for signed-in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end  #should require matching users for 'edit'
      
      it "should require matching uses for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)      
      end  #should require matching uses for 'update'
    
    end # for signed-in users
  end # authentication of edit/update pages
end
