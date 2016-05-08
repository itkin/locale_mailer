require 'active_support/concern'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/keys'
require 'loofah'

module LocaleMailer

  A2HREF = Loofah::Scrubber.new do |node|
    if node.name == "a"
      node.name = "text"
      node.content = [node.content, node.attributes["href"].value].join(' ')
      Loofah::Scrubber::STOP
    end
  end

  module Concern
    extend ActiveSupport::Concern

    included do
      alias_method_chain :mail, :localized_templates
      private :mail, :mail_with_localized_templates, :mail_without_localized_templates
    end

    private

      def mail_with_localized_templates(options = {}, &block)
        begin
          mail_without_localized_templates(options, &block)
        rescue ActionView::MissingTemplate => e
          options.symbolize_keys!

          # i18n_path = [
          #   Rails.configuration.locale_mailer_path_prefix,
          #   options[:template_path] || mailer_name.gsub('/','.').underscore,
          #   options[:template_name] || action_name
          # ].compact.join('.')


          if I18n.exists? i18n_path(options), I18n.locale
            locale_options = instance_public_variables_to_hash
            options[:subject] = subject_from_locale(i18n_path(options), locale_options) unless options.key?(:subject)
            mail_without_localized_templates options do |format|
              html_body = body_from_locale i18n_path(options), locale_options, options
              format.html {
                html_body
              }
              format.text {
                Loofah.scrub_fragment(html_body, LocaleMailer::A2HREF).to_text
              }
            end
          else
            raise e
          end
        end
      end

      def i18n_path options
        [
          Rails.configuration.locale_mailer_path_prefix,
          options[:template_path] || mailer_name.gsub('/','.').underscore,
          options[:template_name] || action_name
        ].compact.join('.')
      end

      def instance_public_variables_to_hash
        instance_variables.inject({}) do |memo, name|
          if name.to_s.match(/\A@(?!_).*/)
            if instance_variable_get(name).try(:as_json).is_a? Hash
              flatten_hash(instance_variable_get(name).as_json).each do |(k,v)|
                memo["#{name.to_s.gsub(/\A@/,'')}_#{k}".to_sym] = v
              end
            else
              memo[name.to_s.gsub(/\A@/,'').to_sym] = instance_variable_get(name)
            end
          end
          memo
        end
      end

      def flatten_hash(hash)
        hash.each_with_object({}) do |(k, v), h|
          if v.is_a? Hash
            flatten_hash(v).map do |h_k, h_v|
              h["#{k}_#{h_k}".to_sym] = h_v
            end
          else
            h[k] = v
          end
        end
      end

      def subject_from_locale i18n_path, locale_options
        view_context.t([i18n_path, :subject].join('.'), locale_options)
      end

      def body_from_locale i18n_path, locale_options, options
        render inline:  view_context.text([i18n_path, :body].join('.'), locale_options),
           layout: options[:layout] || _layout
      end

  end
end

