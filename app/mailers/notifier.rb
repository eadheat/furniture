# encoding: UTF-8

class Notifier < ActionMailer::Base
  default from: Rails.configuration.notifier_from_field

  def send_contact_to_us(name, contact, message)
    puts "Notifier"
    @name = name
    @contact = contact
    @message = message
    mail(
      to: "eadheat@gmail.com",
      subject: "Contact message form #{@name}"
    )
  end

end