When /^I run the rake task "([^\"]*)"$/ do |task|
  %x(rake #{task} RAILS_ENV=test)
end