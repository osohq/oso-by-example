#!/bin/bash
# 1.0 Clear the existing policy and facts data.
TEST_SCRIPT_DIR="$( dirname -- "${BASH_SOURCE[0]}" )"

# 1.0 Clear the existing policy and facts data.
oso-cloud clear --confirm

# 2.0 Load a new policy.
oso-cloud policy "${TEST_SCRIPT_DIR}/../policy.polar"

# 3.0 Add facts data.
oso-cloud tell has_role User:paula "admin" Organization:org_1
oso-cloud tell has_role User:greg "employee" Organization:org_1
oso-cloud tell has_role User:ashley "employee" Organization:org_4

# 4.0 Perform authorization checks
oso-cloud authorize User:paula "admin_view" Organization:org_1
oso-cloud authorize User:greg "employee_view" Organization:org_1
oso-cloud authorize User:ashley "employee_view" Organization:org_4
oso-cloud authorize User:ashley "admin_view" Organization:org_4
oso-cloud authorize User:ashley "employee_view" Organization:org_1