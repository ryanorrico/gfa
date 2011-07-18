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


end
