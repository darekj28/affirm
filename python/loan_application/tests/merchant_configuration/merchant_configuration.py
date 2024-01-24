import dataclasses
import unittest
from unittest.mock import patch
import json
from flask import Response, url_for
from decimal import Decimal

from loan_application.app.implementation import submit_merchant_config
from loan_application.models.merchants.merchant import MerchantConfiguration
from loan_application.repo.merchant.api import get_merchant_configuration
from loan_application.repo.merchant.api import update_merchant_prequal_configuration

_EXISTING_MERCHANT_ID = "4f572866-0e85-11ea-94a8-acde48001122"
_NON_EXISTING_MERCHANT_ID = "55555-AaAaA-4444-BbBb"

class MerchantConfigurationTestCase(unittest.TestCase):

    def test_merchant_configuration_exisiting_merchants(self):
        params = {
        "body" : {
            "minimum_loan_amount" : Decimal('200'),
            "maximum_loan_amount" : Decimal('1000'),
            "prequal_enabled" : True
            }
        }

        #results and expected results for existing merchants
        result_with_exisiting_merchant = submit_merchant_config(
            merchant_id=_EXISTING_MERCHANT_ID,
            **params
            )
        expected_result_with_existing_merchant = {
            "merchant_configuration_id":
            get_merchant_configuration(_EXISTING_MERCHANT_ID).merchant_configuration_id
        }

        self.assertEqual(result_with_exisiting_merchant, expected_result_with_existing_merchant)


    def test_merchant_configuration_non_exisiting_merchants(self):
        params = {
        "body" : {
            "minimum_loan_amount" : Decimal('200'),
            "maximum_loan_amount" : Decimal('1000'),
            "prequal_enabled" : True
            }
        }

        #results and expected results for non-existing merchants
        result_with_non_exisiting_merchant = submit_merchant_config(
            merchant_id=_NON_EXISTING_MERCHANT_ID,
            **params
            )
        expected_result_with_non_existing_merchant = {
            "status_code": 400,
            "content_type": 'application/json',
            "response_data": {
                "field": "merchant_id",
                "message": "Could not find that merchant."
            }
        }

        #test correct status code is returned
        self.assertEqual(
            result_with_non_exisiting_merchant.status_code,
            expected_result_with_non_existing_merchant["status_code"]
            )

        #test correct message is displayed
        response_data = json.loads(result_with_non_exisiting_merchant.get_data(as_text=True))
        self.assertEqual(
            response_data,
            expected_result_with_non_existing_merchant["response_data"]
        )

    def test_merchant_prequal_configuration(self):
        params_prequal_true = {
        "body" : {
            "minimum_loan_amount" : Decimal('200'),
            "maximum_loan_amount" : Decimal('1000'),
            "prequal_enabled" : True
            }
        }

        params_prequal_false = {
        "body" : {
            "minimum_loan_amount" : Decimal('200'),
            "maximum_loan_amount" : Decimal('1000'),
            "prequal_enabled" : False
            }
        }

        #test for prequal enabled
        submit_merchant_config(
            merchant_id=_EXISTING_MERCHANT_ID,
            **params_prequal_true
            )

        #results and expected results for prequal enabled
        result_prequal_enabled = get_merchant_configuration(_EXISTING_MERCHANT_ID).prequal_enabled
        expected_result_prequal_enabled = True

        self.assertEqual(result_prequal_enabled, expected_result_prequal_enabled)

        #test for prequal disabled
        submit_merchant_config(
            merchant_id=_EXISTING_MERCHANT_ID,
            **params_prequal_false
            )

        #results and expected results for prequal_disabled
        result_prequal_disabled = get_merchant_configuration(_EXISTING_MERCHANT_ID).prequal_enabled
        expected_result_prequal_disabled = False

        self.assertEqual(result_prequal_disabled, expected_result_prequal_disabled)


    def test_updated_loan_configuration(self):
        params_update_loans_true = {
        "body" : {
            "minimum_loan_amount" : Decimal('3000'),
            "maximum_loan_amount" : Decimal('50000'),
            "prequal_enabled" : True
            }
        }

        #test for updated loans
        submit_merchant_config(
            merchant_id=_EXISTING_MERCHANT_ID,
            **params_update_loans_true
            )

        #results and expected results for prequal enabled
        result_updated_loans = (
            get_merchant_configuration(_EXISTING_MERCHANT_ID).minimum_loan_amount,
            get_merchant_configuration(_EXISTING_MERCHANT_ID).maximum_loan_amount
        )
        expected_result_updated_loans = (
            params_update_loans_true["body"]['minimum_loan_amount'],
            params_update_loans_true["body"]['maximum_loan_amount'],
        )

        self.assertEqual(result_updated_loans, expected_result_updated_loans)

    def test_invalid_loan_amounts(self):
        params_invalid_loan_amounts = {
        "body" : {
            "minimum_loan_amount" : Decimal('60000'),
            "maximum_loan_amount" : Decimal('2000'),
            "prequal_enabled" : True
            }
        }

        #test for invalid loan amount inputted by merchant
        submit_merchant_config(
            merchant_id=_EXISTING_MERCHANT_ID,
            **params_invalid_loan_amounts
            )

        #results and expected results for invalid loan amounts
        result_invalid_loan_amounts = submit_merchant_config(
            merchant_id=_EXISTING_MERCHANT_ID,
            **params_invalid_loan_amounts
            )

        expected_result_invalid_loan_amounts = {
            "status_code": 400,
            "content_type": 'application/json',
            "response_data": {
                "field": "minimum_loan_amount",
                "message": "Maximum loan amount must be larger than minimum loan amount."
            }
        }

        #test correct error status code is returned
        self.assertEqual(
            result_invalid_loan_amounts.status_code,
            expected_result_invalid_loan_amounts["status_code"]
        )

        #test correct message is displayed
        response_data = json.loads(result_invalid_loan_amounts.get_data(as_text=True))
        self.assertEqual(
            response_data,
            expected_result_invalid_loan_amounts["response_data"]
        )
