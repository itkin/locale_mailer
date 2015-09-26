module LocaleMailer
  class Railtie < Rails::Railtie
    initializer 'locale_mailer.actionview' do
      ActiveView::Base.send :include, LocaleMailer::ActionViewHelpers
    end
  end
end