class LoanappController < ApplicationController
  def initialize_loan_application
    content_type = mimetype = "application/json"
    initial_loan_app = InitialLoanApplication.new(params)
    if initial_loan_app.invalid?
      response = {
        message: "Invalid request."
      }
      render(json: response, content_type: content_type, mimetype: mimetype, status: :bad_request) && return
    end
    merchant_id = params[:merchant_id]
    requested_amount = initial_loan_app.requested_amount_cents.to_f / 100
    currency = params[:currency].downcase
    if currency != "usd"
      response = {
        field: "currency",
        message: "Only USD is supported presently."
      }
      render(json: response, content_type: content_type, mimetype: mimetype, status: :bad_request) && return
    end
    merchant_conf = Merchants.instance.get_merchant_configuration(merchant_id)
    if merchant_conf.nil?
      response = {
        field: "merchant_id",
        message: "Could not find that merchant.#{merchant_conf}"
      }
      render(json: response, content_type: content_type, mimetype: mimetype, status: :bad_request) && return
    end

    loan_application_id = LoanApplications.instance.create(merchant_id, requested_amount, currency)

    response = {
      loan_application_id: loan_application_id,
      next_step: "identity",
      submit_url: "#{request.protocol}#{request.host_with_port}/api/v1/loanapplication/#{loan_application_id}/identity"
    }
    render json: response, content_type: content_type, mimetype: mimetype, status: :ok
  end

  def submit_exit
    content_type = mimetype = "application/json"
    response = {
      message: "Goodbye."
    }
    render json: response, content_type: content_type, mimetype: mimetype, status: :ok
  end
end
