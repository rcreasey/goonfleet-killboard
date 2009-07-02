Given /^I have no Alliances$/ do
  Alliance.delete_all
end

Then /^I should have at least ([0-9]+) Alliances$/ do |count|
  Alliance.find(:all).count.should >= count.to_i
end

Then /^I should see the Alliance "([^\"]*)"$/ do |name|
  Alliance.find_by_name( name ).name.should eql( name )
end

Given /^the following (.+) records?$/ do |factory, table|  
  table.hashes.each do |hash|  
    Factory(factory.downcase, hash)  
  end  
end

Then /^the Alliance "([^\"]*)" has attribute "([^\"]*)" set to "([^\"]*)"$/ do |name, attrib, value|
  Alliance.find_by_name(name)[attrib.to_sym].should eql( value )
end
