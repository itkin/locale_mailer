module LocaleMailer
  module ActionViewHelpers

    #
    # Retrieve and wrap a locale into a tag (p per default)
    # If the locale sends back an array, build a collection of tags
    #
    def text locale, opts = {}
      tag = opts.key?(:tag) ? opts.delete(:tag) :  :p
      array_to_tags t(locale, opts), tag
    end

    #
    # Allow t to parse array retrieved from locale
    #
    def t *args
      str  = super
      opts = args.extract_options!.except(:throw, :raise)
      if str.is_a?(Array) and not opts.empty?
        str.map { |item| I18n.interpolate(item, opts) unless item.nil? }.map(&:to_s)
      else
        str
      end
    end

    #
    # Build a collection of tags from an array
    # todo : Check potential security issue here, use with caution
    #
    def array_to_tags array, tag_name = nil
      Array.wrap(array).flatten.map do |line|
        if tag_name
          content_tag tag_name, line.to_s.html_safe
        else
          line.to_s.html_safe
        end
      end.join.html_safe
    end

  end
end