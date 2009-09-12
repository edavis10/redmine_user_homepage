class UserHomepagesController < ApplicationController
  unloadable
  before_filter :redirect_to_welcome_if_anonymous

  def show
    user_homepage_roles = Role.find_all_by_id(Setting.plugin_redmine_user_homepage['roles'])

    memberships = User.current.memberships.all(:include => 'roles')
    if memberships.any? {|membership|
        membership.roles.any? {|role| user_homepage_roles.include?(role) }
      }
      redirect_to :controller => 'projects', :action => 'show', :id => User.current.projects.first(:order => 'id ASC')
    else
      redirect_to_welcome
    end
    
  end

  private

  def redirect_to_welcome
    redirect_to :controller => 'welcome', :action => 'index'
  end
  
  def redirect_to_welcome_if_anonymous
    redirect_to_welcome unless User.current.logged?
  end
end
