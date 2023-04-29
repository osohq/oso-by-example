actor User {}

resource Organization {
  roles = ["viewer", "owner"];
  permissions = ["view", "edit"];

  "view" if "viewer";
  "edit" if "owner";
  "viewer" if "owner";
}

resource Repository {
  roles = ["viewer", "owner"];
  permissions = ["view", "edit"];
  relations = { repository_container: Organization };

  "view" if "viewer";
  "edit" if "owner";
  "viewer" if "owner";
  "viewer" if "viewer" on "repository_container";
  "owner" if "owner" on "repository_container";
}
