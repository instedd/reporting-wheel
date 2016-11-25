require 'bundler/capistrano'

set :rvm_ruby_string, '1.9.3'

set :application, "reportingwheel"
set :repository,  "https://github.com/instedd/reporting-wheel.git"
set :deploy_via, :remote_cache
set :user, 'ec2-user'

default_environment['TERM'] = ENV['TERM']

after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do ; end

  task :symlink_configs, :roles => :app do
    %W(database nuntium printing_config).each do |file|
      run "ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config/"
    end
  end
end

namespace :foreman do
  desc 'Export the Procfile to Ubuntu upstart scripts'
  task :export, :roles => :app do
    run "echo -e \"PATH=$PATH\\nPUMA_OPTS=$PUMA_OPTS\\nRAILS_ENV=production\" >  #{current_path}/.env"
    run "cd #{current_path} && sudo /usr/local/bin/bundle exec foreman export upstart /etc/init -t #{current_path}/etc/upstart -f #{current_path}/Procfile -a #{application} -u #{user} --concurrency=\"delayed=1,puma=1,web=0\""
  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{application} || sudo restart #{application}"
  end
end

before "deploy:start", "deploy:migrate"
before "deploy:restart", "deploy:migrate"
after "deploy:update_code", "deploy:symlink_configs"
after "deploy:update", "foreman:export"    # Export foreman scripts
after "deploy:restart", "foreman:restart"   # Restart application scripts
