require 'spec_helper'

class MyMailerClass < ActionMailer::Base
  include LocaleMailer::Concern
  default :to => 'toto@gmail.com', :from => "titi@gmail.com"

  def method_without_view_template
    @name = "toto"
    @link = "http://localhost.local"
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
  it "does't exposes private methods" , focus: true do
    expect(MyMailerClass.action_methods.to_a.sort).to eq %w(method_with_view_template method_without_view_template)
  end
  context "when no view and a locale entry", focus: true do
    let(:email){ MyMailerClass.method_without_view_template}
    it 'parses locale and render html' do
      expect(email.html_part.decoded).to eq "<p>line 1</p><p>line 2</p><p><a href=\"http://localhost.local\">Click here</a></p>"
    end
    it 'parses locale and render text' do
      expect(email.text_part.decoded).to eq "\nline 1\n\nline 2\n\nClick here http://localhost.local\n"
    end
  end
  context "when no view an no locale entry" do
    let(:email){ MyMailerClass.method_with_view_template}
    it "raises ActionView::MissingTemplate error" do
      expect{
        email.text_part.decoded
      }.to raise_error(ActionView::MissingTemplate)
    end
  end
end
