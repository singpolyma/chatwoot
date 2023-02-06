class DeeplinkController < ActionController::Base
  before_action :authenticate_user!
  before_action :fetch_account

  def email
    v = params[:value]
    contact = @account.contacts.find_by(email: v)
    contact ||= @account.contacts.create!(name: v, email: v)
    redirect_to "/app/accounts/#{@account.id}/contacts/#{contact.id}"
  end

  def phone_number
    v = params[:value]
    contact = @account.contacts.find_by(phone_number: v)
    contact ||= @account.contacts.create!(name: v, phone_number: v)
    redirect_to "/app/accounts/#{@account.id}/contacts/#{contact.id}"
  end

  def custom_attribute
    attr = params[:attribute]
    v = params[:value]
    contact = @account.contacts
      .where("custom_attributes->>? = ?", attr, v)
      .first
    contact ||= @account.contacts.create!(name: v, custom_attributes:
      { attr.to_sym => v })
    redirect_to "/app/accounts/#{@account.id}/contacts/#{contact.id}"
  end

  private

  def fetch_account
    @account = current_user.accounts.find(params[:account_id])
    @current_account_user = @account.account_users.find_by(user_id: current_user.id)
  end
end
