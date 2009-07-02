When /^I run the rake task "([^\"]*)"$/ do |task|
  Rake.application[task].invoke
end
