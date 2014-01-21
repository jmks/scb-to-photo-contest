When /I am on the homepage/ do 
  visit root_path
end

Then /I should see text "(.+)"/ do |text|
  page.should have_content(text)
end