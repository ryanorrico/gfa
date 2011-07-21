require 'spec_helper'

describe MicropostsController do

  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end  #should deny access to 'create'
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end  #should deny access to 'destroy
    
  end # access control
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    
    describe "failure" do
    
      before(:each) do
        @attr = { :content => ""}
      end
    
      it "should not create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end  #should not create a micropost
      
      it "should render the home page" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
      end  #should render the home page
    
    end # failure

    describe "success" do

      before(:each) do
        @attr = { :content => "lorem ipsum" }
      end
      
      it "should create a micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end  #should create a micropost
      
      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end  #should redirect to the home page
      
      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end  #should have a flash message
      
    end # success
  end # POST 'create'
  
  
    describe "DELETE 'destroy'" do
      
      describe "for an unauthorized user" do
        
        before(:each) do
          @user = Factory(:user)
          wrong_user = Factory(:user, :email => Factory.next(:email))
          test_sign_in(wrong_user)
          @micropost = Factory(:micropost, :user => @user)
        end
        
        it "should deny access" do
          delete :destroy, :id => @micropost
          response.should redirect_to(root_path)
        end  #should deny access
        
      end # for an unauthorized user
      
      describe "for an authorized user" do
        
        before(:each) do
          @user = test_sign_in(Factory(:user))
          @micropost = Factory(:micropost, :user => @user)
        end
        
        it "should destroy the micropost" do
          lambda do
            delete :destroy, :id => @micropost
          end.should change(Micropost, :count).by(-1)    
        end  #should destroy the micropost
      end # for an authorized user
    end # DELETE 'destroy'
    
end
