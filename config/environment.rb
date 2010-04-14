
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  config.gem "json", :version => '1.2.4'
  config.gem "httparty", :version => '0.4.3'
 
  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  config.action_controller.session = {
    :session_key => '_RepresentMe_session',
    :secret      => '71388a6c19b824f2068d369060a6a16bcc52cc0cde978efe82e35175cd005a7735e1ba2ece24e5cc41a16e72b445393dd826fe951f6535bcbe6354daa26e8073'
  }
end
