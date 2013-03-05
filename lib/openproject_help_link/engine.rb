require 'rails/engine'

module OpenprojectHelpLink
  class Engine < ::Rails::Engine

    config.to_prepare do
      require 'redmine/plugin'

      spec = Bundler.environment.specs['openproject_help_link'][0]

      Redmine::Plugin.register :openproject_help_link do
        name 'OpenProject Help Link Changer'
        author ((spec.authors.kind_of? Array) ? spec.authors[0] : spec.authors)
        author_url spec.homepage
        description spec.description
        version spec.version

        settings :default => {"help_link_target" => "https://www.openproject.org/projects/support"},
                 :partial => "settings/openproject_help_link_settings.html.erb"

        Redmine::MenuManager.map :top_menu do |menu|
          if Setting.table_exists?
            menu.delete :help
            menu.push :help, Redmine::Info.help_url, :last => true
          end
        end
      end

      unless Redmine::Info.included_modules.include?(OpenprojectHelpLink::InfoPatch)
          Redmine::Info.send(:include, OpenprojectHelpLink::InfoPatch)
      end
    end
  end
end