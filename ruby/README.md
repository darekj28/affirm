# Loan Application Translation Support

## Installation Guide

Requires Ruby 3.0.0.
1. `$ gem install bundler`
2. `$ bundle install`

## Development

### Running the Server
Run `rails s`. This sets up a server at http://127.0.0.1:3000.

## Manual Tests
While running the server, you can navigate to `http://127.0.0.1:3000/api-docs` to use the OpenAPI UI to test.

Some helpful tips:
- The schemas at the bottom will show you expected types.
- Clicking on the method type (e.g. `POST`) to the left of the API route will open more details. From there, clicking `Try it out` on the right-hand side will open a panel to make an API request.

If you prefer, you can also use cURL to run tests. A sample cURL is below:
1. `$ curl -X POST http://127.0.0.1:3000/api/v1/loanapplication -H "Content-Type: application/json" -d '{"currency": "usd"}'`


### Local Integration Tests
1. `$ bundle exec rspec loan_application/spec/`

### Style
This repository uses rswag for documentation and the UI. To refresh these items, run the following:
1. `$ rake rswag:specs:swaggerize`
This repository uses standard for style. To run the linter on the codebase, run the following:
1. `$ bundle exec standardrb --fix`

## Code Layout

Location (under `loan_application`) | Usage
------ | ------
`app/controllers/loanapp_controller`   | Implementation of API endpoints at `/api/v1/loanapplication`
`app/controllers/merchant_config_controller` | Implementation of API endpoints at `/api/v1/merchantconfig`
`app/models` | In-memory data models and validators
`app/storage` | In-memory loan application data
`config/routes.rb` | Router
`spec/requests` | Local integration tests
`spec/swagger` | API contract

## Implementation Notes

- The `storage` classes use a `Singleton` type, which only allows for one instance of the class, since they are meant to store data for the life of the server.
