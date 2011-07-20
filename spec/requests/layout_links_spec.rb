require 'spec_helper'

describe "LayoutLinks" do

  describe "GET /layout_links" do

    it "should have a home page at '/'" do
      get '/'
      response.should have_selector('title', :content => "Home")
    end  #should have a home page at '/'

    it "should have a contact page at '/contact'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
    end  #should have a contact page at '/contact'
    
    it "should have a help page at '/help'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
    end  #should have a help page at '/help'
    
    it "should have an about page at '/about'" do
      get '/about'
      response.should have_selector('title', :content => "About")   
    end  #should have an about page at '/about'
  end
  
  
    it "should have the right links on the layout" do
      visit root_path
      response.should have_selector('title', :content => "Home" )
    
      click_link "About"
      response.should have_selector('title', :content => "About")
      
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      
      visit root_path
      click_link "Sign up now!"
      response.should have_selector('title', :content => "Sign up")
    end  #should have the right links on the layout


    describe "when not signed in" do

      it "should have a sign-in link" do
        visit root_path
        response.should have_selector("a",  :href => signin_path,
                                            :content => "Sign in")
      end  #should have a sign-in link

    end # when not signed in


    describe "when signed in" do
        
        before(:each) do
          @user = Factory(:user)
          visit signin_path
          fill_in :email, :with => @user.email
          fill_in :password, :with => @user.password
          click_button
        end
        
        it "should have a signout link" do
          visit root_path
          response.should have_selector('a',  :href => signout_path,
                                              :content => "Sign out")
        end  #should have a signout link
        
        it "should have a profile link" do
          visit root_path
          response.should have_selector('a',  :href => user_path(@user),
                                              :content => "Profile")
        end  #should have a profile link
      
    end # when signed in
end
