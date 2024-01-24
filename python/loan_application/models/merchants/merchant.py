from dataclasses import dataclass
from decimal import Decimal


@dataclass
class MerchantConfiguration:
    merchant_id: str
    name: str
    minimum_loan_amount: Decimal
    maximum_loan_amount: Decimal
    '''
    Add boolean attribute to represent whether the merchant has the prequal
    feature or not. Set by default to false because unless configured through
    the API endpoint, the prequal feature cannot be enabled.
    '''
    prequal_enabled: bool = False
    '''
    merchant_configuration_id which only exists if merchant set up their
    configuration in order to enable prequal.
    '''
    merchant_configuration_id: str = None
