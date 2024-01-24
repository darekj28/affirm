require_relative "../swagger_helper"

RSpec.describe "api/loanapp", type: :request do
  path "/api/v1/loanapplication/{id}/exit" do
    post "exit" do
      consumes "application/json"
      parameter name: :id, in: :path, type: :string

      response "200", "OK" do
        let(:id) { "abcd" }
        schema "ref" => "#/components/schemas/SubmitExitResponse"
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["message"]).to eq("Goodbye.")
        end
      end
    end
  end
end
