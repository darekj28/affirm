# Set Merchant Configuration Endpoint

## Business Model
Affirm and select merchants want to help users understand their purchasing power earlier in their shopping journey. Affirm is building a new feature that prequalifies users for a loan without requiring them to apply. A Prequal shows users how much of a loan the user will be approved for at checkout. In order to enable the Prequal feature, the merchant first needs to set-up their merchant configurations.

## Endpoint
Endpoint `Set Merchant Configuration` allows a merchant to set up their merchant configuration.
1. In order to configure, the merchant needs to provide:
    - `minimum_loan_amount`, the minimum amount a user can get a loan for (in cents)
    - `maximum_loan_amount`, the maximum amount a user can get a loan for (in cents)
    - `prequal_enabled`, a boolean indicating if the Prequal feature will be enabled for that merchant
2. Upon success, the configs should be saved to a MerchantConfiguration “data table” in the in-memory storage and the endpoint should return a 200.
3. Upon failure, return a 400 if the given request’s merchant_id does not exist in the in-memory storage.

## Setting Up Your Development Environment
**Install your virtual environment**. Please note this requires Python3.7+

```bash=
$ python3 -m venv .venv
$ . . venv/bin/activate
(.venv) $ pip3 install -r requirements.txt
(.venv) $ python setup.py develop -N
```
**Ensure your tests run**. You must be in the server directory for this.

```python
(.venv) $ nosetests --nologcapture loan_application/tests/
.........
---------------------------------------------------------------------
Ran 9 tests in 0.014s

OK
```


**Run the Server and access the Open API v3.0 Portal**
```python
(.venv) $ python loan_application/app/
```

Then, navigate to http://0.0.0.0:8001/ui/. You should now be able to make JSON requests to the API through the Open API v3.0 UI

## Updates I made to the inherited zip files

**Updated `loan_application/requirements.txt` with new versions of connexion and nose:**

```
connexion[swagger-ui]
connexion~=2.14.2
nose2
```
**Updated `.venv/lib/python3.11/site-packages/nose/suite.py` and `.venv/lib/python3.11/site-packages/nose/case.py`:**

Instead of `import collections`:
```
import collections.abc
```

**Updated where `collection.Callable` was being called in these files, I updated it to:**

```
collections.abc.Callable
```

## Creating Merchant Config

**Merchant Configuration Model**

`loan_application/models/merchants/merchant.py`

Updated `MerchantConfiguration` Schema to include the boolean `prequal_enabled` and the `merchant_configuration_id`.
Adding these attributes to the schema allows us to hold whether a given merchant has the prequalification feature for a loan
enabled and upon enabling, the associated ID of the configuration.

Design choices:

-Please note, by default, `prequal_enabled` is set to the boolean value `False` as to activate the prequalification feature, a merchant needs to submit a request to the configuration endpoint. This default setting was implemented to facilitate the addition of the `prequal_enabled` attribute to an existing data table with recorded instances. Having a default value helps prevent errors when accessing this attribute for merchants that have not yet been configured for the prequalification feature.

-Similarly, please note, by default `merchant_configuration_id` is set to `None` as until a request to the endpoint is made no such ID exists. The generation of a succesful configuration due to an API request produces a `merchant_configuration_id`. This also helps prevent errors when accessing this attribute for merchants that have not yet been configured for the prequalification feature.

-Please note, in order to be able to update instances of a merchant in my database I had to disable the freeze feature of the `dataclass`. This was necessary to ensure that our database contained updated information for the `minimum_loan_amount` and `maximum_loan_amount`, the `prequal_enabled` boolean and the `merchant_configuration_id`.

**Merchant repo and in-memory storage**

`loan_application/repo/merchant/api.py`

As initially provided, it currently maintains in-memory storage for our merchants, and the data does not persist between different executions of our application.

I created an `update_merchant_prequal_configuration` method in our repo which performs CRUD operation for updating the instance
of the merchant which is part of our in-memory storage (is a saved merchant of Affirm) and has submitted a valid request to our
API endpoint to configure prequal feature.
This method performs a check to ensure the merchant exists in our data base, and then proceeds to update the minimum and
maximum loan amounts as provided by the merchant in their request as well as updating the prequal feature.

I imported the below module to generate a `merchant_configuration_id` within the update method upon sucessful configuration:

```
import uuid
```

Design choices:

-Please note I perform checks during the execution of the API endpoint before reaching this method to ensure that the merchant
does exist in our database, however I wanted to add another check within the update method in our repo to account for future calls to the method that did not involve the `MerchantConfiguration` endpoint.

-Please note this method updates `minimum_loan_amount` and `maximum_loan_amounts` as well as the `prequal_enabled` boolean, this is to ensure that when a request is made to our endpoint if there a new min and max loan amounts that they are correctly reflected in our database.

-Please note, a `merchant_configuration_id` is produced only upon succesful update of merchant instance in our database.

**Implementation and API Logic**

`loan_application/app/implementation.py`

I created a `submit_merchant_config` method to handle the logic of the API endpoint. As outlined in the openapi specification, when a request is made to this endpoint a link is made to the `submit_merchant_config method` in the implementation file.

Imported following modules:
```
from loan_application.models.merchants.merchant import MerchantConfiguration
from loan_application.repo.merchant.api import update_merchant_prequal_configuration
```

`submit_merchant_config_method` checks that the merchant exists in our database, only then does it create a class of the merchant to extract parameters from JSON data given to us my the API request with necessary parameters to update. Once we have these parameters, it performs a check to ensure inputted `minimum_loan_amount` and `maximum_loan_amount` are valid, in that the minimum must be less than the maximum. If all parameters are valid, our `update_merchant_prequal_configuration` is called from our repo with our updated parameters so that the instance of our merchant is updated in our database. Upon successful configuration we receive a `merchant_configuration_id` which our method returns along with a 200 status update. Unsuccesful attempts at configuring merchant return a 400 status update.

Design choices:

-Please note, I perform two checks that can return a 400 status response, this is because I wanted the message in the response to indicate whether the request had failed due to invalid `minimum_loan_amount` and `maximum_loan_amount` or because the merchant does not exist in our database.


**Unit Tests for MerchantConfiguration Endpoint**

`loan_application/tests/merchant_configuration/merchant_configuration.py`

Please note five unit tests included in testing file for endpoint:

| Test      | Function |
| ----------- | ----------- |
| `test_merchant_configuration_exisiting_merchants`      | Ensures endpoint works for existing merchants |
| `test_merchant_configuration_non_exisiting_merchants`   | Ensures endpoint returns failure for non-existing merchants |
| `test_merchant_prequal_configuration`  | Ensures prequal_enabled attribute can be updated |
| `test_updated_loan_configuration`  | Ensures loan min and max amounts are updated if different |
| `test_invalid_loan_amounts`  | Ensures endpoint returns failure if inputted loan amounts are invalid |

Design choices:

-I wanted to include a test that would ensure that the prequal_configuration can be "switched" on or off if a merchant changes their mind and wants to disable prequal feature.

-I wanted to ensure endpoint is updating minimum and maximum loan amounts of merchant in our database given the amounts submitted by merchant.

-I wanted to ensure endpoint is not running a "successful" configuration if the min and max loan amounts are invalid.

**Provided API Specification for Endpoint**

`loan_application/app/openapi/openapi.yaml`

Included the given API contract for the endpoint in openapi.yaml file.

```
/api/v1/merchantconfig/{merchant_id}:
 post:
   x-openapi-router-controller: 'loan_application.app.implementation'
   operationId: submit_merchant_config
   parameters:
     - description: Identifier for the merchant
       explode: false
       in: path
       name: merchant_id
       required: true
       schema:
         type: string
       style: simple
   requestBody:
     content:
       application/json:
         schema:
           $ref: '#/components/schemas/CreateMerchantConfigRequest'
   responses:
     200:
       content:
         application/json:
           schema:
             $ref: '#/components/schemas/CreateMerchantConfigResponse'
       description: Request successfully processed
     400:
       content:
         application/json:
           schema:
             $ref: '#/components/schemas/BadInputResponse'
       description: Request invalid
   summary: Create and store the configurations for a Merchant
   tags:
     - Create Merchant Configuration

CreateMerchantConfigRequest:
 example:
   minimum_amount: 30000
   maximum_amount: 200000
   prequal_enabled: true
 properties:
   minimum_amount:
     type: integer
     description: "Minimum amount (in cents) that a consumer can get a loan for"
   maximum_amount:
     type: integer
     description: "Maximum amount (in cents) that a consumer can get a loan for"
   prequal_enabled:
     type: boolean
     description: "Flag to indicate if Prequal feature is enabled for this merchant"
 type: object
 required:
   - minimum_amount
   - maximum_amount
   - prequal_enabled

CreateMerchantConfigResponse:
 example:
   merchant_configuration_id: "3345919e-0e85-11ea-94a8-acde48001122"
 properties:
   merchant_configuration_id:
     type: string
     format: uuid
 type: object
 required:
   - merchant_configuration_id
```
