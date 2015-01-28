package main

import (
	"code.google.com/p/go.net/websocket"
	"time"
)

type Hub struct {
	clients map[*websocket.Conn]*Client
}

type Client struct {
	ws   *websocket.Conn
	ping chan struct{}
}

var (
	Message = websocket.Message
	JSON    = websocket.JSON
)

func NewHub() *Hub {
	return &Hub{map[*websocket.Conn]*Client{}}
}

func (c *Client) Ping(d time.Duration) {
	t := time.NewTicker(d)
	defer t.Stop()

	for {
		select {
		case <-t.C:
			Message.Send(c.ws, "PING")
		case <-c.ping:
			return
		}
	}
}

func (h *Hub) Add(ws *websocket.Conn) *Client {
	h.clients[ws] = &Client{ws, make(chan struct{})}
	return h.clients[ws]
}

func (h *Hub) Remove(ws *websocket.Conn) {
	cli := h.clients[ws]
	close(cli.ping)
	delete(h.clients, ws)
	ws.Close()
}
