const { Oso } = require("oso-cloud");
const express = require("express");

async function start() {
  const app = express();

  // remember to update this before running the server!
  const apiKey = "<please provide your api key here>";
  const oso = new Oso("https://cloud.osohq.com", apiKey);

  /**
   * This is the "view" endpoint for an Organization, keyed on `org_id`.
   *
   * When this endpoint is accessed, we check to see if the actor has "view"
   * permissions on the Organization in question.
   *
   * If you'd like to give the anonymous user access to GET `/org/acme`, you
   * can add this fact to Oso Cloud:
   * ```
   * has_role(User{"anonymous"}, "viewer", Organization{"acme"})
   * ```
   *
   * Because the "viewer" role gives "view" permission, this will grant access.
   */
  app.get(
    "/org/:org_id",
    async (req, res) => {
      const orgId = req.params.org_id;
      const actor = {type: "User", id: "anonymous"};
      const resource = {type: "Organization", id: orgId};

      if (await oso.authorize(actor, "view", resource) === false) {
        // Handle authorization failure
        res.status(404).send("Not Found");
        return;
      }

      res.status(200).send(`{"id": ${orgId}}`);
    }
  );

  /**
   * This is the "edit" endpoint for an Organization, keyed on `org_id`.
   *
   * When this endpoint is accessed, we check to see if the actor has "edit"
   * permissions on the Organization in question.
   *
   * If you'd like to give the anonymous user access to POST `/org/acme`, you
   * can add this fact to Oso Cloud:
   * ```
   * has_role(User{"anonymous"}, "owner", Organization{"acme"})
   * ```
   *
   * Because the "owner" role gives "edit" permission, this will grant access.
   */
  app.post(
    "/org/:org_id",
    async (req, res) => {
      const orgId = req.params.org_id;
      const actor = {type: "User", id: "anonymous"};
      const resource = {type: "Organization", id: orgId};

      if (await oso.authorize(actor, "edit", resource) === false) {
        // Handle authorization failure
        res.status(404).send("Not Found");
        return;
      }

      res.status(200).send(`{"id": ${orgId}}`);
    }
  );

  /**
   * This is the "view" endpoint for an Repository, keyed on `repo_id`.
   *
   * When this endpoint is accessed, we check to see if the actor has "view"
   * permissions on the Repository in question.
   *
   * A repository belongs to an Organization, given the `repository_container`
   * relation. Our policy declares that some roles on an Organization, give some
   * permissions on a Repository:
   * ```
   * "viewer" if "viewer" on "repository_container";
   * ```
   *
   * To construct the relation between an instance of a Repository and an instance
   * of the Organization, we add a fact to Oso Cloud:
   * ```
   * has_relation(Repository{"code"}, "repository_container", Organization{"acme"})
   * ```
   *
   * If you'd like to give the "anonymous" user access to GET `/repo/code`, you
   * can add this fact to Oso Cloud:
   * ```
   * has_role(User{"anonymous"}, "viewer", Organization{"acme"})
   * ```
   *
   * Because the "viewer" role on Organization{"acme"} gives the "viewer" role on
   * Repository{"code"} (given the "repository_container" relation), this will grant
   * access.
   */
  app.get(
    "/repo/:repo_id",
    async (req, res) => {
      const repoId = req.params.repo_id;
      const actor = {type: "User", id: "anonymous"};
      const resource = {type: "Repository", id: repoId};

      if (await oso.authorize(actor, "view", resource) === false) {
        // Handle authorization failure
        res.status(404).send("Not Found");
        return;
      }

      res.status(200).send(`{"id": ${repoId}}`);
    }
  );

  /**
   * This is the "edit" endpoint for an Repository, keyed on `repo_id`.
   *
   * When this endpoint is accessed, we check to see if the actor has "edit"
   * permissions on the Repository in question.
   *
   * A repository belongs to an Organization, given the `repository_container`
   * relation. Our policy declares that some roles on an Organization, give some
   * permissions on a Repository:
   * ```
   * "owner" if "owner" on "repository_container";
   * ```
   *
   * To construct the relation between an instance of a Repository and an instance
   * of the Organization, we add a fact to Oso Cloud:
   * ```
   * has_relation(Repository{"code"}, "repository_container", Organization{"acme"})
   * ```
   *
   * If you'd like to give the "anonymous" user access to GET `/repo/code`, you
   * can add this fact to Oso Cloud:
   * ```
   * has_role(User{"anonymous"}, "owner", Organization{"acme"})
   * ```
   *
   * Because the "owner" role on Organization{"acme"} gives the "owner" role on
   * Repository{"code"} (given the "repository_container" relation), this will grant
   * access.
   */
  app.post(
    "/repo/:repo_id",
    async (req, res) => {
      const repoId = req.params.repo_id;
      const actor = {type: "User", id: "anonymous"};
      const resource = {type: "Repository", id: repoId};

      if (await oso.authorize(actor, "edit", resource) === false) {
        // Handle authorization failure
        res.status(404).send("Not Found");
        return;
      }

      res.status(200).send(`{"id": ${repoId}}`);
    }
  );

  app.listen(8000);
}

start();
