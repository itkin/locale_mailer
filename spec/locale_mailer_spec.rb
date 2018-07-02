require 'spec_helper'

class MyObject
  def as_json *args
    {'name' => 'my object'}
  end
end
class MyMailerClass < ActionMailer::Base
  include LocaleMailer::Concern
  default :to => 'toto@gmail.com', :from => "titi@gmail.com"

  def method_without_view_template
    @name = "toto"
    @link = "http://localhost.local"
    @an_object = MyObject.new
    mail
  end

  def method_with_view_template
    mail
  end

end

describe LocaleMailer do
  it 'has a version number' do
    expect(LocaleMailer::VERSION).not_to be nil
  end
  it "does't exposes private methods" do
    expect(MyMailerClass.action_methods.to_a.sort).to eq %w(method_with_view_template method_without_view_template)
  end
  context "when no view and a locale entry" do
    let(:email){ MyMailerClass.method_without_view_template}
    it 'parses locale and render html' do
      expect(email.html_part.decoded).to eq "<p>line 1</p><p>line 2</p><p>line 3 my object</p><p><a href=\"http://localhost.local\">Click here</a></p>"
    end
    it 'parses locale and render text' do
      expect(email.text_part.decoded).to eq "\nline 1\n\nline 2\n\nline 3 my object\n\nClick here http://localhost.local\n"
    end
  end
  context "when no view an no locale entry" do
    let(:email){ MyMailerClass.method_with_view_template}
    it "raises ActionView::MissingTemplate error" do
      expect{
        email.text_part.decoded
      }.to raise_error(RuntimeError)
    end
  end
end
