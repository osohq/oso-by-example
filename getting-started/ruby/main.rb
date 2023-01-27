# frozen_string_literal: true

require "oso-cloud"
require "sinatra"

api_key = ENV["OSO_AUTH"]
oso = OsoCloud::Oso.new(url: "https://cloud.osohq.com", api_key: api_key)

helpers do
  def protected!
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    if @auth.provided? and @auth.basic? and @auth.credentials
      return @auth.credentials[0]
    end
    headers["WWW-Authenticate"] = 'Basic realm="restricted", charset="UTF-8"'
    halt 401, "Not Authorized\n"
  end
end

get "/:id" do
  org_id = params["id"]
  username = protected!

  actor = OsoCloud::Value.new(type: "User", id: username)
  resource = OsoCloud::Value.new(type: "Organization", id: org_id)

  if not oso.authorize(actor, "read", resource)
    halt 404, "Not Found\n"
  else
    "Hello, you can \"read\" Organization:#{org_id}"
  end
end

set :port, 8000
