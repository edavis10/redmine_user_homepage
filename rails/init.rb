require 'redmine'

if Rails.env == "test"
  
  # Bootstrap ObjectDaddy since it's needs to load before the Models
  # (it hooks into ActiveRecord::Base.inherited)
  require 'object_daddy'

  # Use the plugin's exemplar_path :nodoc:
  module ::ObjectDaddy
    module RailsClassMethods
      def exemplar_path
        File.join(File.dirname(__FILE__), 'test', 'exemplars')
      end
    end
  end
end

Redmine::Plugin.register :redmine_user_homepage do
  name 'User Homepage'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-misc'
  author_url 'http://www.littlestreamsoftware.com'
  description 'User Homepage is a plugin to set the Redmine homepage to be the Project Overview for specific Roles.'
  version '0.1.0'

  requires_redmine :version_or_higher => '0.8.0'

  settings({
             :partial => 'settings/user_homepage',
             :default => {
               'roles' => []
             }})
end
