package main

import (
	"fmt"
	"net/http"
	"strings"

	oso "github.com/osohq/go-oso-cloud"
)

func main() {
	// remember to update this before running the server!
	apiKey := "<please provide your api key here>"
	osoClient := oso.NewClient("https://cloud.osohq.com", apiKey)

	// This is the endpoint for an Organization.
	//
	// When this endpoint is accessed, we check to see if the actor has "view"
	// or "edit" permissions on the Organization in question.
	http.HandleFunc("/org/", func(w http.ResponseWriter, r *http.Request) {
		var action string

		orgID := strings.TrimPrefix(r.URL.Path, "/org/")

		actor := oso.Instance{Type: "User", ID: "anonymous"}
		resource := oso.Instance{Type: "Organization", ID: orgID}

		switch r.Method {
		case "GET":
			// If you'd like to give the anonymous user access to GET
			// `/org/acme`, you can add this fact to Oso Cloud:
			//
			//  has_role(User{"anonymous"}, "viewer", Organization{"acme"})
			//
			// Because the "viewer" role gives "view" permission, this will
			// grant access.
			action = "view"
		case "POST":
			// If you'd like to give the anonymous user access to POST
			// `/org/acme`, you can add this fact to Oso Cloud:
			//
			//  has_role(User{"anonymous"}, "owner", Organization{"acme"})
			//
			// Because the "owner" role gives "edit" permission, this will
			// grant access.
			action = "edit"

		default:
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
			return
		}

		allowed, e := osoClient.Authorize(actor, action, resource)
		if e != nil || !allowed {
			// Handle authorization failure
			http.Error(w, "Not Found", http.StatusNotFound)
			return
		}

		fmt.Fprintf(w, "{\"id\": \"%s\"}", orgID)
	})

	// This is the endpoint for a Repository.
	//
	// When this endpoint is accessed, we check to see if the actor has "view"
	// or "edit" permissions on the Repository in question.
	//
	// A repository belongs to an Organization, given the
	// `repository_container` relation. Our policy declares that some roles on
	// an Organization give some permissions on a Repository:
	//
	//  "viewer" if "viewer" on "repository_container";
	//  "owner" if "owner" on "repository_container";
	//
	// To construct the relation between an instance of a Repository and an
	// instance of the Organization, we add a fact to Oso Cloud:
	//
	//  has_relation(Repository{"code"}, "repository_container",
	//		Organization{"acme"})
	//
	http.HandleFunc("/repo/", func(w http.ResponseWriter, r *http.Request) {
		var action string

		repoID := strings.TrimPrefix(r.URL.Path, "/repo/")

		actor := oso.Instance{Type: "User", ID: "anonymous"}
		resource := oso.Instance{Type: "Repository", ID: repoID}

		switch r.Method {
		case "GET":
			// If you'd like to give the anonymous user access to GET
			// `/repo/code`, you can add this fact to Oso Cloud:
			//
			//  has_role(User{"anonymous"}, "viewer", Organization{"acme"})
			//
			// Because the "viewer" role on Organization{"acme"} gives the
			// "viewer" role on Repository{"code"} (given the
			// "repository_container" relation), this will grant access.
			action = "view"
		case "POST":
			// If you'd like to give the anonymous user access to POST
			// `/repo/code`, you can add this fact to Oso Cloud:
			//
			//  has_role(User{"anonymous"}, "owner", Organization{"acme"})
			//
			// Because the "owner" role on Organization{"acme"} gives the
			// "owner" role on Repository{"code"} (given the
			// "repository_container" relation), this will grant access.
			action = "edit"

		default:
			http.Error(w, "Method Not Allowed", http.StatusMethodNotAllowed)
			return
		}

		allowed, e := osoClient.Authorize(actor, action, resource)
		if e != nil || !allowed {
			// Handle authorization failure
			http.Error(w, "Not Found", http.StatusNotFound)
			return
		}

		fmt.Fprintf(w, "{\"id\": \"%s\"}", repoID)
	})

	http.ListenAndServe(":8000", nil)
}
