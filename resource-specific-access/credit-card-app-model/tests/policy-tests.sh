#!/bin/bash
# 1.0 Clear the existing policy and facts data.
TEST_SCRIPT_DIR="$( dirname -- "${BASH_SOURCE[0]}" )"

# 1.0 Clear the existing policy and facts data.
oso-cloud clear --confirm

# 2.0 Load a new policy.
oso-cloud policy "${TEST_SCRIPT_DIR}/../policy.polar"

# 3.0 Add facts data.
oso-cloud tell has_role User:paula owner CardAccount:paulas-account-123
oso-cloud tell has_role User:kristian member CardAccount:paulas-account-123

oso-cloud tell has_role User:paula card_holder CreditCard:paulas-card
oso-cloud tell has_role User:kristian card_holder CreditCard:kristians-card

oso-cloud tell has_role User:kristian member RewardsProgram:rewards-r-us

# Create a resource-resource relationship
oso-cloud tell has_relation CreditCard:paulas-card parent_account CardAccount:paulas-account-123
oso-cloud tell has_relation CreditCard:kristians-card parent_account CardAccount:paulas-account-123

# 4.0 Perform authorization checks
# True
oso-cloud authorize User:paula add_card CardAccount:paulas-account-123 \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"

oso-cloud authorize User:paula view_accounts CardAccount:paulas-account-123 \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"

oso-cloud authorize User:paula modify_accounts CardAccount:paulas-account-123 \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"

oso-cloud authorize User:paula view_account CreditCard:paulas-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"

oso-cloud authorize User:paula make_transactions CreditCard:paulas-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "is_active CreditCard:paulas-card Boolean:true"

oso-cloud authorize User:paula dispute_transactions CreditCard:paulas-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"

oso-cloud authorize User:paula modify_limits CreditCard:paulas-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "is_active CreditCard:paulas-card Boolean:true"

oso-cloud authorize User:paula view_account CreditCard:kristians-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \

oso-cloud authorize User:paula make_transactions CreditCard:kristians-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "is_active CreditCard:kristians-card Boolean:true"

oso-cloud authorize User:paula dispute_transactions CreditCard:kristians-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \

oso-cloud authorize User:paula modify_limits CreditCard:kristians-card \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "is_active CreditCard:kristians-card Boolean:true"

oso-cloud authorize User:kristian rewards RewardsProgram:rewards-r-us \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"

oso-cloud authorize User:kristian bronze_rewards RewardsProgram:rewards-r-us \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "rewards_status CardAccount:paulas-account-123 bronze"

oso-cloud authorize User:kristian silver_rewards RewardsProgram:rewards-r-us \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "rewards_status CardAccount:paulas-account-123 silver"

oso-cloud authorize User:kristian gold_rewards RewardsProgram:rewards-r-us \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "rewards_status CardAccount:paulas-account-123 gold"

oso-cloud authorize User:kristian platinum_rewards RewardsProgram:rewards-r-us \
    -c "is_active CardAccount:paulas-account-123 Boolean:true" \
    -c "rewards_status CardAccount:paulas-account-123 platinum"

# False
oso-cloud authorize User:kristian add_card CardAccount:paulas-account-123
oso-cloud authorize User:kristian view_accounts CardAccount:paulas-account-123
oso-cloud authorize User:kristian modify_accounts CardAccount:paulas-account-123

oso-cloud authorize User:kristian bronze_rewards RewardsProgram:rewards-r-us

oso-cloud authorize User:kristian platinum_rewards RewardsProgram:rewards-r-us \
    -c "is_active CardAccount:paulas-account-123 Boolean:true"