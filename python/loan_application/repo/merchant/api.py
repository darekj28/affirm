from dataclasses import dataclass
from decimal import Decimal
from typing import Dict, Optional
from loan_application.models.merchants.merchant import MerchantConfiguration
import uuid


@dataclass(frozen=True)
class _MerchantConfigurationsRepo:
    repo: Dict[str, MerchantConfiguration]


_REPO = _MerchantConfigurationsRepo(
    repo={
        '4f572866-0e85-11ea-94a8-acde48001122': MerchantConfiguration(
            merchant_id='4f572866-0e85-11ea-94a8-acde48001122',
            name="Zelda's Stationary",
            minimum_loan_amount=Decimal('100.00'),
            maximum_loan_amount=Decimal('3000.00')
        )
    }
)


def get_merchant_configuration(
        merchant_id: str) -> Optional[MerchantConfiguration]:
    return _REPO.repo.get(merchant_id)

'''
Update method to configure existing merchants with prequal enabled and new min
and max loan values.
'''
def update_merchant_prequal_configuration(
        merchant_id: str,
        minimum_loan_amount: Decimal,
        maximum_loan_amount: Decimal,
        prequal_enabled: bool,
) -> Optional[str]:
    #retrieve merchant from repo
    merchant_to_update = get_merchant_configuration(merchant_id)
    if merchant_to_update:
        #after checking that the merchant is in the repo, update parameters
        merchant_to_update.minimum_loan_amount = minimum_loan_amount
        merchant_to_update.maximum_loan_amount = maximum_loan_amount
        merchant_to_update.prequal_enabled = prequal_enabled
        #create an id for this configuration and add it to data table
        merchant_configuration_id = str(uuid.uuid1())
        merchant_to_update.merchant_configuration_id = merchant_configuration_id
        return merchant_configuration_id
    #if the merchant was not in our database return None
    return
