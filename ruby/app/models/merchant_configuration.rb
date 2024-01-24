# frozen_string_literal: true

class MerchantConfiguration
  include ActiveModel::Validations

  validates :merchant_id, presence: true
  validates :merchant_name, presence: true
  validates :minimum_loan_amount, presence: true, numericality: true
  validates :maximum_loan_amount, presence: true, numericality: true

  def initialize(merchant_id, merchant_name, minimum_loan_amount, maximum_loan_amount)
    @merchant_id = merchant_id
    @merchant_name = merchant_name
    @minimum_loan_amount = minimum_loan_amount
    @maximum_loan_amount = maximum_loan_amount
  end
end
