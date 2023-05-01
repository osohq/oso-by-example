[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?machine=basicLinux32gb&repo=558558532&ref=main&devcontainer_path=.devcontainer%2Fdotnet%2Fdevcontainer.json)

# Anatomy of the sample application

The sample application comprises two routes: `/org` and `/repo`, for the `Organization` and `Repository` objects. Each
route accepts a path parameter corresponding to the object's ID; e.g., `/org/acme` is accessing the `acme`
`Organization`. Both routes accept `GET` and `POST` requests.

This sample application is integrated with Oso Cloud to provide enforcement on the routes. It is intended to serve as an
example, so please make changes to better resemble a more familiar domain!

## Starter policy

This application assumes the [starter policy](../starter_policy.polar) is active in your Oso Cloud environment.

# Running the sample application

Grab an API key from your Oso Cloud environment, and update the source code with your key:

```csharp
// remember to update this before running the server!
const string ApiKey = "<please provide your api key here>"
```

Now you can run the webserver:
```bash
dotnet run --project=app
```

# Making requests

To authorize requests, Oso needs to know which Actor is performing an action.

To keep the implementation of this sample application simple, all requests assume the actor is `User{"anonymous"}`.
```csharp
var actor = new OsoCloud.Value("User", "anonymous");
```

So, this request is authorized for the `User{"anonymous"}` actor:

```bash
curl localhost:8000/org/acme
```

You can use whatever HTTP client you like for these requests - for these examples, we'll be using `curl`.

# Configuring authorization data with facts

By default, all routes will return a 404 for all users. To get a successful 200 OK response, you'll need to add some **facts** to Oso Cloud.

## Assigning roles on an `Organization`

The `Organization` resource has two roles:
- the `viewer` role (which grants `view`), and
- the `owner` role (which grants both `view` and `edit`)

By assigning roles to an Actor as a fact, we can grant access. Roles are assigned to individual instances of a resource - in this case, we'll consider `Organization{"acme"}`.

### `GET /org/acme`

This route is enforced:

```csharp
var actor = new OsoCloud.Value("User", "anonymous");
var resource = new OsoCloud.Value("Organization", orgId);

bool allowed = await oso.Authorize(actor, "view", resource);
if (!allowed)
{
    // Handle authorization failure
    return Results.NotFound("Not Found");
}
```

To access this route, you'll need to provide the `view` permission. This can be accomplished by adding a fact, which gives `User{"anonymous"}` the `viewer` role:
- `has_role(User{"anonymous"}, "viewer", Organization{"acme"})`

Now, the following request should succeed:

```bash
curl localhost:8000/org/acme
```

### `POST /org/acme`

This route is enforced:

```csharp
var actor = new OsoCloud.Value("User", "anonymous");
var resource = new OsoCloud.Value("Organization", orgId);

bool allowed = await oso.Authorize(actor, "edit", resource);
if (!allowed)
{
    // Handle authorization failure
    return Results.NotFound("Not Found");
}
```

This time, instead of the `view` permission, you'll need to provide the `edit` permission.

This can be accomplished by adding a fact which gives `User{"anonymous"}` the `owner` role:
- `has_role(User{"anonymous"}, "owner", Organization{"acme"})`

Now, the following request should succeed:

```bash
curl -X POST localhost:8000/org/acme
```

(This route doesn't require a request body, it is just looking for a POST request.)

## Constructing a relation with facts

The resource block definition for `Repository` contains a relation, `repository_container`:

```polar
resource Repository {
  # ...
  relations = { repository_container: Organization };
  # ...
}
```

This allows **associating a Repository with an Organization**. We declare this with a fact, which references:
- a specific instance of a `Repository`, and
- a specific instance of an `Organization`.

For example, if we wanted to declare a relationship from `Repository{"code"}` to `Organization{"acme"}`, we could add
the following fact to Oso Cloud:

- `has_relation(Repository{"code"}, "repository_container", Organization{"acme"})`

This is relevant for a few permissions, defined on the `Repository` resource:
```polar
resource Repository {
  # ...
  "viewer" if "viewer" on "repository_container";
  "owner" if "owner" on "repository_container";
  # ...
}
```

Assuming we declared the relationship between `Repository{"code"}` and `Organization{"acme"}`, this means:
- if an actor has the `viewer` role on `Organization{"acme"}`, they will have the `viewer` role on `Repository{"code"}`
- if an actor has the `owner` role on `Organization{"acme"}`, they will have the `owner` role on `Repository{"code"}`

## `GET /repo/code`

This route is enforced:

```csharp
var actor = new OsoCloud.Value("User", "anonymous");
var resource = new OsoCloud.Value("Repository", repoId);

bool allowed = await oso.Authorize(actor, "view", resource);
if (!allowed)
{
    // Handle authorization failure
    return Results.NotFound("Not Found");
}
```

To access this route, you'll need to provide the `view` permission.

We can grant access by assigning the `viewer` role to `User{"anonymous"}` on `Organization{"acme"}`:
- `has_role(User{"anonymous"}, "viewer", Organization{"acme"})`

Even though this fact does not reference `Repository{"code"}`, assuming the relation mentioned earlier is defined (`has_relation(Repository{"code"}, "repository_container", Organization{"acme"})`), our Polar policy declares that the `view` permission is inferred:

> if an actor has the `viewer` role on `Organization{"acme"}`, they will have the `viewer` role on `Repository{"code"}`

After adding these facts, the following request should succeed:

```bash
curl localhost:8000/repo/code
```

## `POST /repo/code`

This route is enforced:

```csharp
var actor = new OsoCloud.Value("User", "anonymous");
var resource = new OsoCloud.Value("Repository", repoId);

bool allowed = await oso.Authorize(actor, "edit", resource);
if (!allowed)
{
    // Handle authorization failure
    return Results.NotFound("Not Found");
}
```

To access this route, you'll need to provide the `edit` permission.

We can grant access by assigning the `owner` role to `User{"anonymous"}` on `Organization{"acme"}`:
- `has_role(User{"anonymous"}, "owner", Organization{"acme"})`

Again, we're not referencing `Repository{"code"}`, but assuming the relation mentioned earlier is defined (`has_relation(Repository{"code"}, "repository_container", Organization{"acme"})`), the Polar policy declares that the `edit` permission is inferred:

> if an actor has the `owner` role on `Organization{"acme"}`, they will have the `owner` role on `Repository{"code"}`

After adding these facts, the following request should succeed:

```bash
curl -X POST localhost:8000/repo/code
```

# Additional resources

Thanks for taking the time to read through this guide! If you're looking for more information on Oso Cloud and this
client, check out some of the following resources:

- [.NET Client Docs](https://www.osohq.com/docs/reference/client-apis/dotnet)
- [Oso Cloud Documentation](https://www.osohq.com/docs)

If you'd like to get in touch, or need some extra help, [check out our Slack!](https://join-slack.osohq.com/?utm_source=starter-policy-sample-application)
