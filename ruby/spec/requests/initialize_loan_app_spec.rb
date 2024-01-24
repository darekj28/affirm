require_relative "../swagger_helper"

RSpec.describe "api/loanapp", type: :request do
  path "/api/v1/loanapplication" do
    post "create loan application" do
      consumes "application/json"
      parameter name: :loanapp, in: :body, schema: {"$ref" => "#/components/schemas/CreateLoanApplicationRequest"}

      response "400", "Bad Request" do
        let(:loanapp) { {merchant_id: "abcd", requested_amount_cents: "abcd", currency: "CAD"} }
        schema "$ref" => "#/components/schemas/BadInputResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("Invalid request.")
        end
      end

      response "400", "Bad Request" do
        let(:loanapp) { {merchant_id: "abcd", requested_amount_cents: 50, currency: "CAD"} }
        schema "$ref" => "#/components/schemas/BadInputResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["field"]).to eq("currency")
          expect(data["message"]).to eq("Only USD is supported presently.")
        end
      end

      response "400", "Bad Request" do
        let(:loanapp) { {merchant_id: "abcd", requested_amount_cents: 50, currency: "USD"} }
        schema "$ref" => "#/components/schemas/BadInputResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["field"]).to eq("merchant_id")
          expect(data["message"]).to eq("Could not find that merchant.")
        end
      end

      response "200", "OK" do
        let(:loanapp) { {merchant_id: "4f572866-0e85-11ea-94a8-acde48001122", requested_amount_cents: 50, currency: "USD"} }
        schema "$ref" => "#/components/schemas/LoanApplicationResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["next_step"]).to eq("identity")
        end
      end

      response "200", "OK" do
        let(:loanapp) { {merchant_id: "4f572866-0e85-11ea-94a8-acde48001122", requested_amount_cents: 50, currency: "uSd"} }
        schema "$ref" => "#/components/schemas/LoanApplicationResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["next_step"]).to eq("identity")
        end
      end
    end
  end
end
