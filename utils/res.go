package utils

import (
	"encoding/json"
	"net/http"
)

func JSON(w http.ResponseWriter, val interface{}) {
	w.Header().Set("Content-Type", "application/json")
	b, _ := json.MarshalIndent(val, "", "  ")
	if string(b) == "null" {
		w.Write([]byte("[]"))
		return
	}
	w.Write(b)
}
