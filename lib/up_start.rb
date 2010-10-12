module UpStart
  @@roles = []

  def roles
    @@roles
  end

  def role(role, watches)
    @@roles << role

    namespace :upstart do

      unless @meta_tasks_defined
        namespace :all do
          desc 'Install the upstart scripts to /etc/init'
          task :install do
            up_start.roles.each { |role| send(role).send(:install) }
          end

          desc 'Start everything'
          task :start do
            up_start.roles.each { |role| send(role).send(:start) }
          end

          desc 'Stop everything'
          task :stop do
            up_start.roles.each { |role| send(role).send(:stop) }
          end
        end
      end
      @meta_tasks_defined = true

      namespace role do
        desc "Install the #{role.to_s.capitalize} related upstart script to /etc/init"
        task :install, :roles => role do
          watches.each do |watch|
            up_start.roles.each { |role| send(role).send(watch).send(:install) }
          end
        end

        %w( start status stop ).each do |command|
          desc "#{command.capitalize} #{role.to_s.capitalize}"
          task command, :roles => role do
            watches.each do |watch|
              up_start.roles.each { |role| send(role).send(watch).send(command) }
            end
          end
        end

        watches.each do |watch|
          namespace watch do
            desc "Install the #{up_start.service_name(application, role, watch)} related upstart script to /etc/init"
            task :install, :roles => role do
              run "cd #{release_path} && cp #{up_start.service_config_file(current_path, application, role, watch)} /etc/init/"
            end

            %w( start status stop ).each do |command|
              desc "#{command.capitalize} #{up_start.service_name(application, role, watch)}"
              task command, :roles => role do
                run "#{command} #{up_start.service_name(application, role, watch)}"
              end
            end
          end
        end
      end # namespace role

    end # namespace :upstart

  end # def role

  def service_config_file(current_path, application, role, watch)
    config_dir = fetch(:upstart_config_path, nil) || File.join(current_path, 'config', 'upstart')

    File.join(config_dir, "#{ up_start.service_name(application, role, watch) }.conf")
  end

  def service_name(application, role, watch)
    if stage = fetch(:stage, nil)
      "#{application}-#{role}-#{stage}-#{watch}"
    else
      "#{application}-#{role}-#{watch}"
    end
  end
end # module UpStart

Capistrano.plugin :up_start, UpStart
