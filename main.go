package main

import (
	"code.google.com/p/go.net/websocket"
	"encoding/json"
	"fmt"
	"github.com/codegangsta/negroni"
	"github.com/daryl/qstn/lib/db"
	"github.com/daryl/qstn/middle/ajaxify"
	"github.com/daryl/qstn/middle/static"
	"github.com/daryl/qstn/utils"
	"gopkg.in/mgo.v2/bson"
	"io/ioutil"
	"net/http"
	"os"
)

var (
	bytz []byte
	JSON = websocket.JSON
	hub  = map[*sock]int{}
)

func main() {
	neg := negroni.New()
	mux := http.NewServeMux()
	por := os.Getenv("PORT")

	neg.Use(static.New("./public"))
	neg.Use(ajaxify.New(index))

	mux.HandleFunc("/", index)
	mux.HandleFunc("/q/", handleQ)

	mux.Handle("/s", websocket.Handler(vote))

	bytz, _ = ioutil.ReadFile("./public/index.html")

	neg.UseHandler(mux)
	neg.Run(":" + por)
}

func vote(ws *websocket.Conn) {
	defer ws.Close()

	var err error
	var entry *Entry

	conn := &sock{ws}
	hub[conn] = 1337

	fmt.Println("New Socket")
	fmt.Println(hub)

	coll := db.D.C("entries")

	for {
		err = JSON.Receive(ws, &entry)

		if err != nil {
			fmt.Println("Close Socket")
			delete(hub, conn)
			fmt.Println(hub)
			return
		}

		opts := bson.M{
			"options": entry.Options,
		}

		coll.Update(bson.M{
			"slug": entry.Slug,
		}, bson.M{
			"$set": opts,
		})

		for c, _ := range hub {
			JSON.Send(c.ws, entry)
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
