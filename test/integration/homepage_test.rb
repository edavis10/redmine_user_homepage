require File.dirname(__FILE__) + '/../test_helper'

class ProjectOverviewHooksTest < ActionController::IntegrationTest
  should "change the homepage to the project overview once a user with the 'user homepage' Role logs in" do
    setup_plugin_configuration
    user = User.generate_with_protected!(:password => 'test', :password_confirmation => 'test')
    user.reload
    assert user.valid?, user.errors.full_messages
    project = Project.generate!
    Member.generate!(:user_id => user.id, :project_id => project.id, :role_ids => [@configured_role_one.id])
    
    get '/'
    assert_response :redirect
    assert_redirected_to '/welcome'
    
    log_user(user.login, 'test')

    get '/'
    assert_response :redirect
    assert_redirected_to "/projects/#{project.identifier}"
  end
end
