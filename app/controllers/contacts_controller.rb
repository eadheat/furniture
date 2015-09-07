class ContactsController < ApplicationController
  skip_before_filter :authenticate_user!

  def send_contact
    puts params[:name]
    puts params[:contact]
    puts params[:message]
    
    if params[:name].present? && params[:contact].present? && params[:message].present?
      Notifier.send_contact_to_us(params[:name], params[:contact], params[:message]).deliver
      head(:ok)
    else
      head(:forbidden)
    end
  end
end