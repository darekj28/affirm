# frozen_string_literal: true

class UserLoanApplication
  include ActiveModel::Validations

  def initialize(params)
    @loan_application_id = params[:loan_application_id]
    @state = params[:state]
    @merchant_id = params[:merchant_id]
    @requested_amount = params[:requested_amount]
    @currency = params[:currency]
    @user_input = params[:user_input]
    @user_input_events = params[:user_input_events]
    @final_decision = params[:final_decision]
    @decision_events = params[:decision_events]
    @selected_terms_id = params[:selected_terms_id]
  end
end
