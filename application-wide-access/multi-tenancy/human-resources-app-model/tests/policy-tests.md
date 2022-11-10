# Test the Authorization Policy in the Oso Cloud UI

## Add Authorization Data Using the Facts Page
These facts are formatted for the [Facts page](https://ui.osohq.com/facts/) in the Oso Cloud UI.

1. *Paula* has the role *admin* within the *Org 1* organization.
    ```ruby
    has_role User:paula "admin" Organization:org_1
    ```

1. *Greg* has the role *employee* within the *Org 1* organization.
    ```ruby
    has_role User:greg "employee" Organization:org_1
    ```

1. *Ashley* has the role *employee* within the *Org 4* organization.
    ```ruby
    has_role User:ashley "employee" Organization:org_4
    ```

## Run Authorization Checks Using the Explain Page
These authorization checks are formatted for the [Explain page](https://ui.osohq.com/explain/) in the Oso Cloud UI.

1. Does the user *Paula* have *admin view* permissions within the *Org 1* organization?
    ```ruby
    User:paula "admin_view" Organization:org_1
    ```

1. Does the user *Greg* have *employee view* permissions within the *Org 1* organization?
    ```ruby
    User:greg "employee_view" Organization:org_1
    ```

1. Does the user *Ashley* have *employee view* permissions within the *Org 4* organization?
    ```ruby
    User:ashley "employee_view" Organization:org_4
    ```

1. Does the user *Ashley* have *admin view* permissions within the *Org 4* organization?
    ```ruby
    User:ashley "admin_view" Organization:org_4
    ```

1. Does the user *Ashley* have *employee view* permissions within the *Org 1* organization?
    ```ruby
    User:ashley "employee_view" Organization:org_1
    ```