$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'action_mailer'
require 'locale_mailer'

# Emulate AV railtie
require 'action_view'
ActionMailer::Base.include(ActionView::Layouts)

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true

# Disable available locale checks to avoid warnings running the test suite.
I18n.enforce_available_locales = false

FIXTURE_LOAD_PATH = File.expand_path('fixtures', File.dirname(__FILE__))
ActionMailer::Base.view_paths = FIXTURE_LOAD_PATH

I18n.load_path << File.expand_path('fixtures/locales.yml', File.dirname(__FILE__))

module Rails
  def self.root
    File.expand_path('../', File.dirname(__FILE__))
  end
end

ActionView::Base.include LocaleMailer::ActionViewHelpers
