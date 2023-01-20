# Multi-tenancy Authorization Pattern Code Example
## Prerequisites
1. [Install the Oso Cloud CLI client](https://ui.osohq.com/install/?tab=cli).
1. Set the `OSO_AUTH` environment variable to your Oso Cloud API key ([Get an API Key](https://www.osohq.com/docs/get-started/quickstart/cli-quickstart#get-your-oso-cloud-api-key)).

## Understanding the Model
Read the tutorial [Writing Your First Policy](https://www.osohq.com/docs/tutorials/writing-your-first-policy/authz-for-multi-tenancy-apps). It discusses this multi-tenancy example in more detail.

## Running the Examples
Run the test script in this example's folder `./tests/policy-tests.sh`.
```bash
> ./tests/policy-tests.sh
```
The script will:
1. Upload the policy file `./policy.polar`
1. Upload a set of facts to Oso Cloud (facts are defined in the script)
1. Perform various authorization checks against the policy, facts, and context facts.