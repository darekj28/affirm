# Upward Take Home Assignment

Welcome to the Affirm take home assignment for the Upwards program! In this particular question, you will be designing a miniature version of Affirm with the guided instructions below. 

You can complete this assignment in your preferred language. Depending on the language you pick, please look in the associated subdirectory to find additional language-specific instructions for setup or completing the question.

![Affirm](https://images.ctfassets.net/4rc1asww3mw7/3t33TDADBJ0avzWhw67onU/c3f7556ecaf70a106c69f924fe3aff69/Affirm_buy_now_pay_later.jpg)

## Creating a Merchant Configuration
Affirm and select merchants want to help users understand their purchasing power earlier in their shopping journey. Affirm is building a new feature that prequalifies users for a loan without requiring them to apply. A Prequal shows users how much of a loan the user will be approved for at checkout. In order to enable the Prequal feature, the merchant first needs to set-up their merchant configurations. 

Your task is to create an endpoint `Set Merchant Configuration` that allows a merchant to set up their merchant configuration. 

1. In order to configure, the merchant needs to provide:
    - `minimum_loan_amount`, the minimum amount a user can get a loan for (in cents)
    - `maximum_loan_amount`, the maximum amount a user can get a loan for (in cents)
    - `prequal_enabled`, a boolean indicating if the Prequal feature will be enabled for that merchant
2. Upon success, the configs should be saved to a MerchantConfiguration “data table” in the in-memory storage and the endpoint should return a 200.
3. Upon failure, return a 400 if the given request’s merchant_id does not exist in the in-memory storage.
4. Add additional unit tests in code for various edge cases you deem necessary.
5. Write a [README](https://guides.github.com/features/wikis/) that explains:
    - What design decisions did you consider when implementing this endpoint?
    - What are some future improvements or extensions that can be added to make this endpoint more robust?

__Notes:__
- You have the flexibility to modify the schema of the MerchantConfiguration object.
- You can assume that only US currency is supported at this time.