module LocaleMailer
  class Railtie < Rails::Railtie

    config.locale_mailer_path_prefix = nil

    initializer 'locale_mailer.actionview' do
      ActionView::Base.send :include, LocaleMailer::ActionViewHelpers
    end

    initializer 'locale_mailer.actionmailer' do
      ActionMailer::Base.send :include, LocaleMailer::Concern
    end

  end
end