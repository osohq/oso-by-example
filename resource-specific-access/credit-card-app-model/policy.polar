actor User {}

resource CardAccount {
    roles = [
        "owner",
        "member"
    ];
    permissions = [
        "add_card",
        "view_accounts",
        "modify_accounts"
    ];
}

resource CreditCard {
    roles = [
        "card_holder"
    ];

    permissions = [
        "view_account",
        "make_transactions",
        "dispute_transactions",
        "modify_limits"
    ];

    relations = {parent_account: CardAccount};
}

resource RewardsProgram {
    roles = [
        "member"
    ];

    permissions = [
        "rewards",
        "bronze_rewards",
        "silver_rewards",
        "gold_rewards",
        "platinum_rewards"
    ];
}

###############################################################################
# CardAccount Rules
###############################################################################
# Each permission is only granted if the user has the appropriate role, and the
# account is active.
has_permission(user: User, "add_card", account: CardAccount) if
    has_role(user, "owner", account) and
    is_active(account, true);

has_permission(user: User, "view_accounts", account: CardAccount) if
    has_role(user, "owner", account) and
    is_active(account, true);

has_permission(user: User, "modify_accounts", account: CardAccount) if
    has_role(user, "owner", account) and
    is_active(account, true);

###############################################################################
# CreditCard Rules
###############################################################################
# Only add the attribute condition is_active(account, true). Users should still
# be able to view their account if their card is inactive.
has_permission(user: User, "view_account", card: CreditCard) if
    (has_role(user, "card_holder", card) or has_role(user, "owner", account)) and
    account matches CardAccount and
    has_relation(card, "parent_account", account) and
    is_active(account, true);

# Only add the attribute condition is_active(account, true). Users should still
# be able to dispute transactions on their account if their card is inactive.
has_permission(user: User, "dispute_transactions", card: CreditCard) if
    (has_role(user, "card_holder", card) or has_role(user, "owner", account)) and
    account matches CardAccount and
    has_relation(card, "parent_account", account) and
    is_active(account, true);

# Add both attribute conditions: is_active(account, true) and
# is_active(card, true). User's should not be able to make transactions if
# their account OR their card is inactive.
has_permission(user: User, "make_transactions", card: CreditCard) if
    (has_role(user, "card_holder", card) or has_role(user, "owner", account)) and
    account matches CardAccount and
    has_relation(card, "parent_account", account) and
    is_active(account, true) and
    is_active(card, true);

# Add both attribute conditions: is_active(account, true) and
# is_active(card, true). User's should not be able to modify credit card
# limits if their account OR their card is inactive.
has_permission(user: User, "modify_limits", card: CreditCard) if
    has_role(user, "owner", account) and
    account matches CardAccount and
    has_relation(card, "parent_account", account) and
    is_active(account, true) and
    is_active(card, true);

###############################################################################
# RewardsProgram Rules
###############################################################################
# The rewards tier is the default tier in the rewards program. It only requires
# a user to be a member of an active CardAccount and enrolled as a member of
# the RewardsProgram. Therefore, no additional rewards_status rule is needed.
has_permission(user: User, "rewards", rewards_program: RewardsProgram) if
    has_role(user, "member", rewards_program) and
    account matches CardAccount and
    has_role(user, "member", account) and
    is_active(account, true);

has_permission(user: User, "bronze_rewards", rewards_program: RewardsProgram) if
    has_role(user, "member", rewards_program) and
    account matches CardAccount and
    has_role(user, "member", account) and
    is_active(account, true) and
    rewards_status(account, "bronze");

has_permission(user: User, "silver_rewards", rewards_program: RewardsProgram) if
    has_role(user, "member", rewards_program) and
    account matches CardAccount and
    has_role(user, "member", account) and
    is_active(account, true) and
    rewards_status(account, "silver");

has_permission(user: User, "gold_rewards", rewards_program: RewardsProgram) if
    has_role(user, "member", rewards_program) and
    account matches CardAccount and
    has_role(user, "member", account) and
    is_active(account, true) and
    rewards_status(account, "gold");

has_permission(user: User, "platinum_rewards", rewards_program: RewardsProgram) if
    has_role(user, "member", rewards_program) and
    account matches CardAccount and
    has_role(user, "member", account) and
    is_active(account, true) and
    rewards_status(account, "platinum");