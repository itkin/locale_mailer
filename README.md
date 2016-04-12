# LocaleMailer

[![Build Status](https://travis-ci.org/itkin/locale_mailer.svg)](https://travis-ci.org/itkin/locale_mailer)

Handling action mailer view templates can become a bit heavy when your app has to send a lot of different emails
    
This gem aims at generating email view templates straight from your localization files when no template view is found
     
This is especially relevant for email views with simple content

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

Include `LocaleMailer::Concern` is automatically mixed into ActionMailer::Base during initialization phase. 

Considering the following localization file

```yaml
en:
  my_mailer:
    notify:
      subject: "hello %{user_name}"
      body:
        - line 1
        - line 2
        - '<a href="%{user_link}">Click here</a>'
```

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

1 - If no template view is found by ActionMailer::Base, LocaleMailer will check if there is some locales specified at 
`mailer_name`.`action_name` per default (or whatever :template_path / :template_name options you passed to the `mail` method)

2 - Your instance variables (usually available to views) will be passed to `I18n.translate` for locale interpolation.
 
3 - If your locale returns an array it will be converted in `<p>` tags into the html_part

4 - Link tags present into the locale data will be converted to `text_content href_content` into the text view part of the email, other tags will be stripped  


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/itkin/locale_mailer. This project is intended to be a safe, welcoming space for collaboration bla bla bla ... 


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

