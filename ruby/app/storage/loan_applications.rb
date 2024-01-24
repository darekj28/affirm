# CRUD layer for customer-inputted data for the loan application. Backed by an
# in-memory store, so storage of applications doesn't persist if the server
# restarts. A production service would use durable storage (such as MySQL or
# Postgres) as the backend.

class LoanApplications
  include Singleton

  def initialize
    @apps = {}
  end

  def create(merchant_id, requested_amount, currency)
    loan_application_id = SecureRandom.uuid
    params = {
      "loan_application_id" => loan_application_id,
      "state" => Enums::LoanApplicationState::PENDING_IDENTITY,
      "merchant_id" => merchant_id,
      "requested_amount" => requested_amount,
      "currency" => currency,
      "user_input" => MISSING,
      "user_input_events" => [],
      "final_decision" => MISSING,
      "decision_events" => [],
      "selected_terms_id" => MISSING
    }
    loan_application = UserLoanApplication.new(params)
    @apps[loan_application_id] = loan_application
    loan_application_id
  end
end
