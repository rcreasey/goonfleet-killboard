Given /^I have no Alliances$/ do
  pending
  Alliance.delete_all
end

Then /^I should have ([0-9]+) Alliances$/ do |count|
  Alliance.find(:all).count.should eql( count.to_i )
end

Then /^I should see the Alliance "([^\"]*)"$/ do |name|
  Alliance.find_by_name( name ).name.should eql( name )
end
