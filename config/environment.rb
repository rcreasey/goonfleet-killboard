# ENV['RAILS_ENV'] ||= 'production'

RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'haml', :version => '~> 2.0.3'
  config.gem 'reve', :version => '~> 0.0.115'
  config.gem 'mislav-will_paginate', :version => '~> 2.3.2', :lib => 'will_paginate', :source => 'http://gems.github.com'

  config.time_zone = 'UTC'

  config.action_controller.session = {
    :session_key => '_goonfleet-killboard_session',
    :secret      => '34ea1fd39db1caf78290c145f03bbaee882e336c8c2575cb8499fea756a0de975985d545c5074db50faef91afeff93f535dc13ec914423bccfb28305a28932e0'
  }

  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # config.active_record.schema_format = :sql

  # config.active_record.observers = :cacher, :garbage_collector
end
