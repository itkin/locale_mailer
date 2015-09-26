$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'combustion'

Combustion.initialize! :action_view, :action_mailer do
  config.action_mailer.view_paths = File.expand_path('fixtures', File.dirname(__FILE__))
  config.i18n.load_path << File.expand_path('fixtures/locales.yml', File.dirname(__FILE__))
end

