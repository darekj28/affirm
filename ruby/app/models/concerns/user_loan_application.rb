# frozen_string_literal: true

class UserLoanApplication
  include ActiveModel::Validations

  def initialize(params)
    @loan_application_id = params[:loan_application_id]
  end
end
