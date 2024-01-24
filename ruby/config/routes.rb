Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  match "/api/v1/loanapplication" => "loanapp#initialize_loan_application", :via => :post
  match "/api/v1/loanapplication/:id/exit" => "loanapp#submit_exit", :via => :post

  match "/api/v1/merchantconfig/:id" => "merchant_config#submit_merchant_config", :via => :post
end
