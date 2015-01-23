package main

import (
	"code.google.com/p/go.net/websocket"
	"encoding/json"
	"github.com/codegangsta/negroni"
	"github.com/daryl/qstn/lib/db"
	"github.com/daryl/qstn/middle/ajaxify"
	"github.com/daryl/qstn/middle/static"
	"github.com/daryl/qstn/utils"
	"gopkg.in/mgo.v2/bson"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

var (
	bytz []byte
	hubs = map[string]*Hub{}
)

func main() {
	neg := negroni.New()
	mux := http.NewServeMux()
	por := os.Getenv("PORT")

	neg.Use(static.New("./public"))
	neg.Use(ajaxify.New(index))

	mux.HandleFunc("/", index)
	mux.Handle("/s/", websocket.Handler(socket))
	mux.HandleFunc("/q/", handleQ)

	bytz, _ = ioutil.ReadFile("./public/index.html")

	neg.UseHandler(mux)
	neg.Run(":" + por)
}

func socket(ws *websocket.Conn) {
	var err error
	var raw []byte
	var entry *Entry

	// Use the URL path as id
	id := ws.Request().URL.Path

	// Create hub if not exist
	if _, ok := hubs[id]; !ok {
		hubs[id] = NewHub()
	}

	hub := hubs[id]
	cli := hub.Add(ws)

	coll := db.D.C("entries")

	// Keep Heroku websockets alive by
	// pinging the client every 30 secs
	go cli.Ping(30 * time.Second)

	defer func() {
		hub.Remove(ws)
		garbage(id)
	}()

	for {
		err = Message.Receive(ws, &raw)

		if err != nil {
			return
		}

		err = json.Unmarshal(raw, &entry)

		opts := bson.M{
			"options": entry.Options,
		}

		coll.Update(bson.M{
			"slug": entry.Slug,
		}, bson.M{
			"$set": opts,
		})

		for cws, _ := range hub.clients {
			JSON.Send(cws, entry)
		}

	}
}

func index(w http.ResponseWriter, r *http.Request) {
	w.Write(bytz)
}

func handleQ(w http.ResponseWriter, r *http.Request) {
	segs := utils.GetSegs(r)
	size := len(segs)

	switch {
	case size == 2:
		handleQId(w, r)
		return
	case size > 2:
		w.WriteHeader(404)
		return
	}

	if r.Method == "POST" {
		qPost(w, r)
		return
	}

	w.WriteHeader(404)
}

func handleQId(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		w.WriteHeader(404)
		return
	}

	seg := utils.GetSeg(r, 1)

	var entry *Entry

	coll := db.D.C("entries")

	coll.Find(bson.M{
		"slug": seg,
	}).One(&entry)

	if entry == nil {
		w.WriteHeader(404)
		return
	}

	utils.JSON(w, entry)
}

func qPost(w http.ResponseWriter, r *http.Request) {
	var entry *Entry

	json.NewDecoder(r.Body).Decode(&entry)

	coll := db.D.C("entries")

	entry.genSlug()

	coll.Insert(entry)

	utils.JSON(w, entry)
}

func garbage(id string) {
	if len(hubs[id].clients) == 0 {
		delete(hubs, id)
	}
}
