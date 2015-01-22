package ajaxify

import (
	"net/http"
)

type Ajaxify struct {
	handler http.HandlerFunc
}

func New(h http.HandlerFunc) *Ajaxify {
	return &Ajaxify{h}
}

func (a *Ajaxify) ServeHTTP(w http.ResponseWriter, r *http.Request, n http.HandlerFunc) {
	// Disable browser caching when working with dynamic responses.
	w.Header().Set("Cache-Control", "no-cache,no-store,max-age=0,must-revalidate")

	y := r.Header.Get("Sec-WebSocket-Version")
	x := r.Header.Get("X-Requested-With")

	if y == "" && x == "" {
		a.handler.ServeHTTP(w, r)
		return
	}

	n.ServeHTTP(w, r)
}
