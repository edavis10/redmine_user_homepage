# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path

Rails::Initializer.run do |config|
  config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
  config.gem "nofxx-object_daddy", :lib => "object_daddy", :source => "http://gems.github.com"
end

# TODO: The gem or official version of ObjectDaddy doesn't set protected attributes.
def User.generate_with_protected!(attributes={})
  user = User.spawn(attributes) do |user|
    user.login = User.next_login
    attributes.each do |attr,v|
      user.send("#{attr}=", v)
    end
  end
  user.save!
  user
end

# Helpers
class Test::Unit::TestCase
  def configure_plugin(fields={})
    Setting.plugin_redmine_user_homepage = fields.stringify_keys
  end

  def setup_plugin_configuration
    @configured_role_one = Role.generate!
    assert @configured_role_one.valid?
    @configured_role_two = Role.generate!
    @nonconfigured_role_one = Role.generate!    
    
    configure_plugin({
                       'roles' => [@configured_role_one.id, @configured_role_two.id]
                     })
  end
end

# Shoulda
class Test::Unit::TestCase
  def self.should_use_the_default_homepage
    should_redirect_to("the default homepage") { { :controller => 'welcome', :action => 'index' } }
  end
end
