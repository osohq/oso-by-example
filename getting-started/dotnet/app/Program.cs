using Microsoft.AspNetCore.Mvc;
using OsoCloud;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.UseUrls("http://localhost:8000");
var app = builder.Build();

string? apiKey = Environment.GetEnvironmentVariable("OSO_AUTH");
if (apiKey == null)
{
    throw new Exception("OSO_AUTH environment variable not set");
}
var oso = new Oso("https://cloud.osohq.com", apiKey);

app.MapGet("/{orgId}", async ([FromRoute] string orgId,
    [FromHeader(Name = "Authorization")] string? authorization,
    HttpContext http) =>
{
    if (authorization == null)
    {
        http.Response.Headers.Add("WWW-Authenticate", "Basic realm=\"restricted\", charset=\"UTF-8\"");
        return Results.Unauthorized();
    }

    string prefix = "Basic ";
    byte[] decoded = Convert.FromBase64String(authorization.Substring(prefix.Length));
    string username = System.Text.Encoding.UTF8.GetString(decoded).Split(":")[0];

    var actor = new OsoCloud.Value("User", username);
    var resource = new OsoCloud.Value("Organization", orgId);

    bool allowed = await oso.Authorize(actor, "read", resource);
    if (!allowed)
    {
        // Handle authorization failure
        return Results.NotFound("Not Found");
    }

    return Results.Ok($"Hello, you can 'read' Organization:{orgId}");
});

app.Run();
