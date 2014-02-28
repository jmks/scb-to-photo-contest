When /I am on the homepage/ do 
  visit root_path
end

Then /I should be on the homepage/ do
  page.current_path.should eql root_path
end