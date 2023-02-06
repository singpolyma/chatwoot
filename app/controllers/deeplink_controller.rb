class DeeplinkController < ActionController::Base
  before_action :authenticate_user!
  before_action :fetch_account

  def email
    contact = @account.contacts.find_by!(email: params[:value])
    redirect_to "/app/accounts/#{@account.id}/contacts/#{contact.id}"
  end

  def phone_number
    contact = @account.contacts.find_by!(phone_number: params[:value])
    redirect_to "/app/accounts/#{@account.id}/contacts/#{contact.id}"
  end

  def custom_attribute
    contact = @account.contacts
      .where("custom_attributes->>? = ?", params[:attribute], params[:value])
      .first
    raise ActiveRecord::RecordNotFound unless contact
    redirect_to "/app/accounts/#{@account.id}/contacts/#{contact.id}"
  end

  private

  def fetch_account
    @account = current_user.accounts.find(params[:account_id])
    @current_account_user = @account.account_users.find_by(user_id: current_user.id)
  end
end
