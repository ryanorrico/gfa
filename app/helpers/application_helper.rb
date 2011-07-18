module ApplicationHelper
  
  def title
    base_title = "Get Fucking Awesome"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
   image_tag("logo.png", :alt => "Get Fucking Awesome!")  
  end
  
  
  
end
