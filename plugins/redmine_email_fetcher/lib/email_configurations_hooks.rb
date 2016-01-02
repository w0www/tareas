# EmailConfigurationsHooks class
class EmailConfigurationsHooks < Redmine::Hook::ViewListener
  # Add CSS class
  def view_layouts_base_html_head(_context = {})
    stylesheet_link_tag 'email_configurations.css', plugin: 'redmine_email_fetcher'
  end

  # Add Javascript class
  def view_layouts_base_body_bottom(_context = {})
    javascript_include_tag 'email_configurations.js', plugin: 'redmine_email_fetcher'
  end
end
