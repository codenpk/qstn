package main

import (
	"code.google.com/p/go.net/websocket"
)

type sock struct {
	ws *websocket.Conn
}
