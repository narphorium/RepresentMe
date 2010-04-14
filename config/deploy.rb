set :application, "RepresentMe" 
set :domain, "representme.ca"
set :user, "narphorium"

set :repository,  "git://github.com/#{user}/#{application}.git"
set :scm, "git"
set :branch, "master"

set :use_sudo, false
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :rails_env, :production

namespace :deploy do
  task :restart, :roles => :app do
    run "cd #{deploy_to}/current && mongrel_rails cluster::restart"
  end
end

default_run_options[:pty] = true

role :app, domain
role :web, domain
role :db,  domain, :primary => true
