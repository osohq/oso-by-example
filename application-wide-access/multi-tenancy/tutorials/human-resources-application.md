# Exploring Multi-tenancy with a Human Resources Application

In this example you’ll create an authorization model for a multi-tenancy application. Multi-tenancy applications host data and services that belong to several organizations. However, access to data and services should only be granted to authorized members of a particular organization — not across all organizations.

 This pattern of authorization shows up a lot! We’ll use the example of a human resources application and guide you through the 4 steps Oso Cloud provides to build a complete authorization system:

1. Create an authorization policy that models who’s allowed to do what in your application using Polar.
1. Store core authorization data as facts in Oso Cloud.
1. Perform authorization checks against your policy.
1. Monitor and troubleshoot authorization decisions in realtime from Oso Cloud.

So let’s get started!

---

**Additional Resources**

</br>
<p style="text-align:left;">
    <span style="float:right;">
        <a href="1-model-your-app-authz.md">→ Next</a>
    </span>
</p>
