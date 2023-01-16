# Oso by Example
## Prerequisites
1. Create an Oso Cloud account. Go to https://ui.osohq.com.
1. Install the Oso Cloud CLI client.
    ```bash
    curl -L https://cloud.osohq.com/install.sh | bash
    ```
> *__NOTE__*: Some tutorials access the Oso client from within an application. Use the
> [Install page](https://ui.osohq.com/install) to see the language-specific options available.

## Contents
| Tutorial | Code Example | Level | Description | Prerequisites |
|----------|-------------|-------|-------------|---------------|
| **[Writing Your First Policy](https://www.osohq.com/docs/tutorials/writing-your-first-policy/authz-for-multi-tenancy-apps)** | [code](./application-wide-access/multi-tenancy/human-resources-app-model/) | Application-wide Authorization</br>*&mdash;Beginner&mdash;* | *Use Oso Cloud to create an authorization model for a multi-tenancy application.* | None |
| **[Using Attributes to Control Permissions](https://www.osohq.com/docs/tutorials/controlling-permissions-with-attributes/overview)** | [code](./resource-specific-access/credit-card-app-model/) | Resource-specific Authorization<br/>*&mdash;Intermediate&mdash;* | *Model aspects of a credit card app (accounts, transaction limits, rewards program, ect.) using permissions, attributes, and context facts).* | &bull; [Patterns in Relationship Based Access Control](https://www.osohq.com/docs/tutorials/four-steps-to-authz/app-modeling-basics/rebac-patterns)<br/> &bull; [Patterns in Attribute Based Access Control](https://www.osohq.com/docs/tutorials/four-steps-to-authz/app-modeling-basics/abac-patterns)<br/> |
| **[Git Cloud (End-to-End Example)](https://www.osohq.com/docs/tutorials/end-to-end-example)** | [code](https://github.com/osohq/gitcloud) | Resource-specific Authorization<br/>*&mdash;Intermediate&mdash;* | *Use Oso Cloud to enforce authorization in a real world application.* | &bull; [Model Your App's Authorization](https://www.osohq.com/docs/guides/model-your-apps-authz)|