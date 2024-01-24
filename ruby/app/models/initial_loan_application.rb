# frozen_string_literal: true

class InitialLoanApplication
  include ActiveModel::Validations

  attr_accessor :merchant_id, :requested_amount_cents, :currency

  validates :merchant_id, presence: true
  validates :requested_amount_cents, presence: true, numericality: {only_integer: true}
  validates :currency, presence: true, currency: true

  def initialize(params)
    @merchant_id = params[:merchant_id]
    @requested_amount_cents = params[:requested_amount_cents]
    @currency = params[:currency]
  end
end
