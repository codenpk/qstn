package utils

import (
	"net/http"
)

func GetSegs(r *http.Request) []string {
	path := r.URL.Path
	last := len(path) - 1

	if path[:1] == "/" {
		path = path[1:]
		last--
	}

	if path[last:] == "/" {
		path = path[:last]
	}

	return Split(path, "/")
}

func GetSeg(r *http.Request, n int) string {
	return GetSegs(r)[n]
}
