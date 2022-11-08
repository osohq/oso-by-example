# 1. Who uses the application?
#    Users are the actors *who* use the application.
#    Users perform actions within an Organization,
#    as defined in the resource block below.
actor User {}

# 2. What resources that make up the application?
#    Organizations are modeled by this resource block.
#    Organizations are *what* Users interact with in
#    the application.
resource Organization {

# 3. What actions require authorization?
#    Permissions represent the actions Users can
#    perform within an Organization.
  permissions = ["admin_view", "employee_view"];

# 4. How are permissions granted within the application?
#    Roles represent identities Users within
#    Organizations may have.
  roles = ["admin", "employee"];

# 5. How are permissions attached to roles?
#    The combination of roles and permissions are one
#    way to define authorization for a resource.
#    The rules below grant permissions to specific
#    roles as determined by your application's needs.
  "employee_view" if "employee";
  "admin_view" if "admin";
}