require File.dirname(__FILE__) + '/../test_helper'

class UserHomepagesControllerTest < ActionController::TestCase
  def get_homepage
    get :show
  end

  def login_as_user(user)
    @request.session[:user_id] = user.id
  end

  context "routing" do
    should_route :get, "/", :controller => 'user_homepages', :action => 'show'
    should_route :get, "/welcome", :controller => 'welcome', :action => 'index'
    
    should "generate home_path" do
      assert_equal "/", home_path
    end
  end

  context "GET show as an anonymous user" do
    setup do
      setup_plugin_configuration
      get_homepage
    end

    should_use_the_default_homepage
  end

  context "GET show as User without any projects" do
    setup do
      setup_plugin_configuration
      @user = User.generate_with_protected!
      login_as_user(@user)

      get_homepage
    end

    should_use_the_default_homepage
  end

  context "GET show as User with one project" do
    setup do
      setup_plugin_configuration
      @user = User.generate_with_protected!
      login_as_user(@user)
      @project = Project.generate!
    end

    context "with a configured 'user homepage' Role" do
      setup do
        Member.generate!(:user_id => @user.id, :project_id => @project.id, :role_ids => [@configured_role_one.id])
        get_homepage
      end

      should_redirect_to("the project overview") { {:controller => 'projects', :action => 'show', :id => @project.identifier} }
    end

    context "without a configured 'user homepage' Role" do
      setup do
        Member.generate!(:user => @user, :project => @project, :roles => [@nonconfigured_role_one])
        get_homepage
      end

      should_use_the_default_homepage
    end
  end

  context "GET show as User with many projects" do
    setup do
      setup_plugin_configuration
      @user = User.generate_with_protected!
      login_as_user(@user)
      @project = Project.generate!
      @project_two = Project.generate!
      @project_three = Project.generate!

      # TODO: Object daddy is saving the projects but the instance
      # isn't reloading with the new identifier/id/name so it's
      # failing tests
      [@project, @project_two, @project_three].each { |p| p.reload }
      Member.generate!(:user => @user, :project => @project, :roles => [@nonconfigured_role_one])
      Member.generate!(:user => @user, :project => @project_two, :roles => [@nonconfigured_role_one])
    end

    context "with a configured 'user homepage' Role on any project" do
      setup do
        Member.generate!(:user_id => @user.id, :project_id => @project_three.id, :role_ids => [@configured_role_one.id])
        get_homepage
        [@project, @project_two, @project_three].each do |p|
          p.reload
        end
      end

      should_redirect_to("the first project overview") { { :controller => 'projects', :action => 'show', :id => @project.identifier } }
    end

    context "without a configured 'user homepage' Role" do
      setup do
        get_homepage
      end

      should_use_the_default_homepage
    end

  end
end
