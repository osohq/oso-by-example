using Microsoft.AspNetCore.Mvc;
using OsoCloud;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.UseUrls("http://localhost:8000");
var app = builder.Build();

// remember to update this before running the server!
const string ApiKey = "<please provide your api key here>";
var oso = new Oso("https://cloud.osohq.com", ApiKey);

/// <summary>
/// This is the "view" endpoint for an Organization, keyed on `id`.
///
/// When this endpoint is accessed, we check to see if the actor has "view"
/// permissions on the Organization in question.
///
/// If you'd like to give the anonymous user access to GET `/org/acme`, you
/// can add this fact to Oso Cloud:
/// <code>
/// has_role(User{"anonymous"}, "viewer", Organization{"acme"})
/// </code>
///
/// Because the "viewer" role gives "view" permission, this will grant access.
/// </summary>
app.MapGet("/org/{orgId}", async ([FromRoute] string orgId,
    HttpContext http) =>
{
    var actor = new OsoCloud.Value("User", "anonymous");
    var resource = new OsoCloud.Value("Organization", orgId);

    bool allowed = await oso.Authorize(actor, "view", resource);
    if (!allowed)
    {
        // Handle authorization failure
        return Results.NotFound("Not Found");
    }

    return Results.Ok(new Organization { Id = orgId });
});

/// <summary>
/// This is the "edit" endpoint for an Organization, keyed on `id`.
///
/// When this endpoint is accessed, we check to see if the actor has "edit"
/// permissions on the Organization in question.
///
/// If you'd like to give the "anonymous" user access to POST `/org/acme`, you
/// can add this fact to Oso Cloud:
/// <code>
/// has_role(User{"anonymous"}, "owner", Organization{"acme"})
/// </code>
///
/// Because the "owner" role gives "edit" permission, this will grant access.
/// </summary>
app.MapPost("/org/{orgId}", async ([FromRoute] string orgId,
    HttpContext http) =>
{
    var actor = new OsoCloud.Value("User", "anonymous");
    var resource = new OsoCloud.Value("Organization", orgId);

    bool allowed = await oso.Authorize(actor, "edit", resource);
    if (!allowed)
    {
        // Handle authorization failure
        return Results.NotFound("Not Found");
    }

    return Results.Ok(new Organization { Id = orgId });
});

/// <summary>
/// This is the "view" endpoint for an Repository, keyed on `id`.
///
/// When this endpoint is accessed, we check to see if the actor has "view"
/// permissions on the Repository in question.
///
/// A repository belongs to an Organization, given the `repository_container`
/// relation. Our policy declares that some roles on an Organization, give some
/// permissions on a Repository:
/// <code>
/// "viewer" if "viewer" on "repository_container";
/// </code>
///
/// To construct the relation between an instance of a Repository and an instance
/// of the Organization, we add a fact to Oso Cloud:
/// <code>
/// has_relation(Repository{"code"}, "repository_container", Organization{"acme"})
/// </code>
///
/// If you'd like to give the "anonymous" user access to GET `/repo/code`, you
/// can add this fact to Oso Cloud:
/// <code>
/// has_role(User{"anonymous"}, "viewer", Organization{"acme"})
/// </code>
///
/// Because the "viewer" role on Organization{"acme"} gives the "viewer" role on
/// Repository{"code"} (given the "repository_container" relation), this will grant
/// access.
/// </summary>
app.MapGet("/repo/{repoId}", async ([FromRoute] string repoId,
    HttpContext http) =>
{
    var actor = new OsoCloud.Value("User", "anonymous");
    var resource = new OsoCloud.Value("Repository", repoId);

    bool allowed = await oso.Authorize(actor, "view", resource);
    if (!allowed)
    {
        // Handle authorization failure
        return Results.NotFound("Not Found");
    }

    return Results.Ok(new Repository { Id = repoId });
});

/// <summary>
/// This is the "edit" endpoint for an Repository, keyed on `id`.
///
/// When this endpoint is accessed, we check to see if the actor has "edit"
/// permissions on the Repository in question.
///
/// A repository belongs to an Organization, given the `repository_container`
/// relation. Our policy declares that some roles on an Organization, give some
/// permissions on a Repository:
/// <code>
/// "owner" if "owner" on "repository_container";
/// </code>
///
/// To construct the relation between an instance of a Repository and an instance
/// of the Organization, we add a fact to Oso Cloud:
/// <code>
/// has_relation(Repository{"code"}, "repository_container", Organization{"acme"})
/// </code>
///
/// If you'd like to give the "anonymous" user access to GET `/repo/code`, you
/// can add this fact to Oso Cloud:
/// <code>
/// has_role(User{"anonymous"}, "owner", Organization{"acme"})
/// </code>
///
/// Because the "owner" role on Organization{"acme"} gives the "owner" role on
/// Repository{"code"} (given the "repository_container" relation), this will grant
/// access.
/// </summary>
app.MapPost("/repo/{repoId}", async ([FromRoute] string repoId,
    HttpContext http) =>
{
    var actor = new OsoCloud.Value("User", "anonymous");
    var resource = new OsoCloud.Value("Repository", repoId);

    bool allowed = await oso.Authorize(actor, "edit", resource);
    if (!allowed)
    {
        // Handle authorization failure
        return Results.NotFound("Not Found");
    }

    return Results.Ok(new Repository { Id = repoId });
});


app.Run();
