from base64 import b64decode
import os
from flask import Flask, request
from oso_cloud import Oso

api_key = os.environ["OSO_AUTH"]
oso = Oso(url="https://cloud.osohq.com", api_key=api_key)


app = Flask(__name__)


@app.route("/<org_id>")
def get(org_id):
    if not request.headers.get("Authorization"):
        return (
            "Not Authorized",
            401,
            {"WWW-Authenticate": 'Basic realm="restricted", charset="UTF-8"'},
        )

    [username, _] = (
        b64decode(request.headers.get("Authorization").split(" ")[1])
        .decode()
        .split(":")
    )

    actor = {"type": "User", "id": username}
    resource = {"type": "Organization", "id": org_id}

    if not oso.authorize(actor, "read", resource):
        return "Not Found", 404

    return f"Hello, you can \"read\" Organization:{org_id}", 200


if __name__ == "__main__":
    app.run(port=8000)
