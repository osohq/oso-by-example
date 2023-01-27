const express = require("express");
require("dotenv").config();
const { Oso } = require("oso-cloud");

const apiKey = process.env.OSO_AUTH;
const oso = new Oso("https://cloud.osohq.com", apiKey);

async function start() {
  const app = express();

  app.get("/:org_id", async (req, res) => {
    const authorization = req.headers.authorization;

    if (!authorization) {
      res.set("WWW-Authenticate", `Basic realm="restricted", charset="UTF-8"`);
      res.status(401).send("Not Authorized");
      return;
    }

    const [username, _] = new Buffer.from(authorization.split(" ")[1], "base64")
      .toString()
      .split(":");
    const orgId = req.params.org_id;
    const actor = { type: "User", id: username };
    const resource = { type: "Organization", id: orgId };
    if ((await oso.authorize(actor, "read", resource)) === false) {
      // Handle authorization failure
      res.status(404).send("Not Found");
      return;
    }

    res.status(200).send(`Hello, you can "read" Organization:${orgId}`);
  });
  app.listen(8000);
}

start();
