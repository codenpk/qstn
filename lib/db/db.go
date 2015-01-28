package db

import (
	"fmt"
	"gopkg.in/mgo.v2"
	"os"
)

var (
	S *mgo.Session
	D *mgo.Database
)

func init() {
	var err error

	db := fmt.Sprintf("%s:%s@%s/%s",
		os.Getenv("MONGODB_USER"),
		os.Getenv("MONGODB_PASS"),
		os.Getenv("MONGODB_URI"),
		os.Getenv("MONGODB_DB"),
	)

	S, err = mgo.Dial(db)

	if err != nil {
		panic(err)
	}

	D = S.DB(os.Getenv("MONGODB_NAME"))

	D.C("entries").EnsureIndex(mgo.Index{
		Key:        []string{"slug"},
		Unique:     true,
		DropDups:   true,
		Background: true,
		Sparse:     true,
	})
}
