package main

import (
	"fmt"
	"net/http"
	"os"

	oso "github.com/osohq/go-oso-cloud"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		username, _, ok := r.BasicAuth()
		orgID := r.URL.Path[1:]

		if !ok {
			w.Header().Set("WWW-Authenticate", `Basic realm="restricted", charset="UTF-8"`)
			http.Error(w, "Not Authorized", http.StatusUnauthorized)
			return
		}

		if orgID == "" {
			http.Error(w, "Not Found", http.StatusNotFound)
			return
		}

		apiKey := os.Getenv("OSO_AUTH")
		osoClient := oso.NewClient("https://cloud.osohq.com", apiKey)

		actor := oso.Instance{Type: "User", ID: username}
		resource := oso.Instance{Type: "Organization", ID: orgID}

		allowed, e := osoClient.Authorize(actor, "read", resource)
		if e != nil || !allowed {
			// Handle authorization failure
			http.Error(w, "Not Found", http.StatusNotFound)
			return
		}

		fmt.Fprintf(w, "Hello, you can \"read\" Organization:%s", orgID)
	})

	http.ListenAndServe(":8000", nil)
}
