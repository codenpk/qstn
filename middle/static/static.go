package static

import (
	"net/http"
	"strings"
)

type Static struct {
	mux *http.ServeMux
	dir string
}

func New(d string) *Static {
	mux := http.NewServeMux()

	mux.Handle("/", http.FileServer(http.Dir(d)))

	return &Static{mux, d}
}

func (s *Static) ServeHTTP(w http.ResponseWriter, r *http.Request, n http.HandlerFunc) {
	if strings.ContainsRune(r.URL.Path, '.') {
		s.mux.ServeHTTP(w, r)
		return
	}
	n.ServeHTTP(w, r)
}
