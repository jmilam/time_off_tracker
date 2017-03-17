# config valid only for current version of Capistrano
lock "3.7.2"
server "192.168.3.131", port: 22, roles: [:web, :app, :db]

set :repo_url, "git@github.com:jmilam/time_off_tracker.git"
set :application, "time_off_tracker"
set :user, "itadmin"

set :use_sudo, false

set :deploy_via, :remote_cache

set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

## Defaults:
set :scm,           :git
# set :format,        :pretty
# set :log_level,     :debug
set :keep_releases, 5
set :assets_roles, [:web, :app]

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# namespace :puma do
#   desc 'Create Directories for Puma Pids and Socket'
#   task :make_dirs do
#     on roles(:app) do
#       execute "mkdir #{shared_path}/tmp/sockets -p"
#       execute "mkdir #{shared_path}/tmp/pids -p"
#     end
#   end

#   before :start, :make_dirs
# end

namespace :deploy do
#   desc "Make sure local git is in sync with remote."
#   task :check_revision do
#     on roles(:app) do
#       unless `git rev-parse HEAD` == `git rev-parse origin/master`
#         puts "WARNING: HEAD is not the same as origin/master"
#         puts "Run `git push` to sync changes."
#         exit
#       end
#     end
#   end

#   desc 'Initial Deploy'
#   task :initial do
#     on roles(:app) do
#       before 'deploy:restart', 'puma:start'
#       invoke 'deploy'
#     end
#   end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'service nginx restart'
    end
  end

#   before :starting,     :check_revision
#   after  :finishing,    :compile_assets
#   after  :finishing,    :cleanup
#   after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma