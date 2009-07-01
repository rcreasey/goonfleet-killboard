Given /^I have no (Region|Solar System)s$/ do |model|
  model.delete(" ").constantize.delete_all
end

Then /^I should have ([0-9]+) Regions$/ do |count|
  Region.find(:all).count.should eql(count.to_i)
end

Then /^I should have ([0-9]+) Solar Systems$/ do |count|
  SolarSystem.find(:all).count.should eql(count.to_i)
end

Then /^I should see the Solar System "([^\"]*)"$/ do |name|
  SolarSystem.find_by_name( name ).name.should eql( name )
end

Then /^I should see the Region "([^\"]*)"$/ do |name|
  Region.find_by_regionName( name ).name.should eql( name )
end
