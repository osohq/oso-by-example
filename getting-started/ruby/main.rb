# frozen_string_literal: true

require 'oso-cloud'
require 'sinatra'

# remember to update this before running the server!
api_key = '<please provide your api key here>'
oso = OsoCloud::Oso.new(url: 'https://cloud.osohq.com', api_key:)

# This is the "view" endpoint for an Organization, keyed on `id`.
#
# When this endpoint is accessed, we check to see if the actor has "view"
# permissions on the Organization in question.
#
# If you'd like to give the anonymous user access to GET `/org/acme`, you
# can add this fact to Oso Cloud:
# ```
# has_role(User{"anonymous"}, "viewer", Organization{"acme"})
# ```
#
# Because the "viewer" role gives "view" permission, this will grant access.
get '/org/:id' do
  org_id = params['id']

  actor = OsoCloud::Value.new(type: 'User', id: 'anonymous')
  resource = OsoCloud::Value.new(type: 'Organization', id: org_id)

  if !oso.authorize(actor, 'view', resource)
    halt 404, "Not Found\n"
  else
    "{ \"id\": \"#{org_id}\" }"
  end
end

# This is the "edit" endpoint for an Organization, keyed on `id`.
#
# When this endpoint is accessed, we check to see if the actor has "edit"
# permissions on the Organization in question.
#
# If you'd like to give the "anonymous" user access to POST `/org/acme`, you
# can add this fact to Oso Cloud:
# ```
# has_role(User{"anonymous"}, "owner", Organization{"acme"})
# ```
#
# Because the "owner" role gives "edit" permission, this will grant access.
post '/org/:id' do
  org_id = params['id']

  actor = OsoCloud::Value.new(type: 'User', id: 'anonymous')
  resource = OsoCloud::Value.new(type: 'Organization', id: org_id)

  if !oso.authorize(actor, 'edit', resource)
    halt 404, "Not Found\n"
  else
    "{ \"id\": \"#{org_id}\" }"
  end
end

# This is the "view" endpoint for an Repository, keyed on `id`.
#
# When this endpoint is accessed, we check to see if the actor has "view"
# permissions on the Repository in question.
#
# A repository belongs to an Organization, given the `repository_container`
# relation. Our policy declares that some roles on an Organization, give some
# permissions on a Repository:
# ```
# "viewer" if "viewer" on "repository_container";
# ```
#
# To construct the relation between an instance of a Repository and an instance
# of the Organization, we add a fact to Oso Cloud:
# ```
# has_relation(Repository{"code"}, "repository_container", Organization{"acme"})
# ```
#
# If you'd like to give the "anonymous" user access to GET `/repo/code`, you
# can add this fact to Oso Cloud:
# ```
# has_role(User{"anonymous"}, "viewer", Organization{"acme"})
# ```
#
# Because the "viewer" role on Organization{"acme"} gives the "viewer" role on
# Repository{"code"} (given the "repository_container" relation), this will grant
# access.
get '/repo/:id' do
  repo_id = params['id']

  actor = OsoCloud::Value.new(type: 'User', id: 'anonymous')
  resource = OsoCloud::Value.new(type: 'Repository', id: repo_id)

  if !oso.authorize(actor, 'view', resource)
    halt 404, "Not Found\n"
  else
    "{ \"id\": \"#{repo_id}\" }"
  end
end

# This is the "edit" endpoint for an Repository, keyed on `id`.
#
# When this endpoint is accessed, we check to see if the actor has "edit"
# permissions on the Repository in question.
#
# A repository belongs to an Organization, given the `repository_container`
# relation. Our policy declares that some roles on an Organization, give some
# permissions on a Repository:
# ```
# "owner" if "owner" on "repository_container";
# ```
#
# To construct the relation between an instance of a Repository and an instance
# of the Organization, we add a fact to Oso Cloud:
# ```
# has_relation(Repository{"code"}, "repository_container", Organization{"acme"})
# ```
#
# If you'd like to give the "anonymous" user access to GET `/repo/code`, you
# can add this fact to Oso Cloud:
# ```
# has_role(User{"anonymous"}, "owner", Organization{"acme"})
# ```
#
# Because the "owner" role on Organization{"acme"} gives the "owner" role on
# Repository{"code"} (given the "repository_container" relation), this will grant
# access.
post '/repo/:id' do
  repo_id = params['id']

  actor = OsoCloud::Value.new(type: 'User', id: 'anonymous')
  resource = OsoCloud::Value.new(type: 'Repository', id: repo_id)

  if !oso.authorize(actor, 'edit', resource)
    halt 404, "Not Found\n"
  else
    "{ \"id\": \"#{repo_id}\" }"
  end
end

set :port, 8000
