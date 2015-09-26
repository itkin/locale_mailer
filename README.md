# LocaleMailer

Handling action mailer view templates can become a bit messy when your app has to send a lot of different emails
    
This gem aims at generating them from locale when no template view is found, saving you the pain (and the code duplication) to have to create and maintain template view files     

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'locale_mailer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install locale_mailer

## Usage

Include `LocaleMailer::Concern` into your ApplicationMailer (or in any other mailer) to enable the plugin

```ruby
class ApplicationMailer < ActionMailer::Base
  include LocaleMailer::Concern   
  default from: "from@example.com"
  layout 'mailer'
end
```

Then create your mailer method as usual
 
```ruby
class MyMailer < ApplicationMailer
  def notify user
    @user_name = "toto"
    @user_link = "http://localhost.local" 
    mail to: user.email
  end
end

MyMailer.notify.subject
> "hello toto"

MyMailer.notify.html_part.decoded
> "<p>line 1</p><p>line 2</p><p><a href=\"http://localhost.local\">Click here</a></p>" 

MyMailer.notify.text_part.decoded
> "\nline 1\n\nline 2\n\nClick here http://localhost.local\n" 

```

```yaml
en:
  my_mailer_class:
    notify:
      subject: "hello %{user_name}"
      body:
        - line 1
        - line 2
        - '<a href="%{user_link}">Click here</a>'
```

If no template view is found by ActionMailer::Base, LocaleMailer will check if there is some locales specified at 
`mailer_name`.`action_name` per default (or whatever template_path / template_name you passed to the `mail` method)

Your instance variables (usually available to views) will be passed as to `I18n.translate`.
 
If your locale returns an array it will be converted into <p> tags into the html_part

Links tags presents into the locale data will be converted to `text_content href_content`, other tags are stripped  


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/itkin/locale_mailer. This project is intended to be a safe, welcoming space for collaboration bla bla bla ... 


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

