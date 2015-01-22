package main

import (
	"github.com/daryl/qstn/lib/db"
	"github.com/daryl/qstn/utils"
	"gopkg.in/mgo.v2/bson"
)

type Entry struct {
	Id       bson.ObjectId `bson:"_id,omitempty" json:"-"`
	Slug     string        `bson:"slug" json:"slug"`
	Question string        `bson:"question" json:"question"`
	Options  []*Option     `bson:"options" json:"options"`
}

type Option struct {
	Option string `bson:"option" json:"option"`
	Votes  int    `bson:"votes" json:"votes"`
}

func (e *Entry) genSlug() {
	e.Slug = genUniqSlug(8)
}

func genUniqSlug(n int) string {
	var duff interface{}

	coll := db.D.C("entries")
	slug := utils.RandSeq(n)

	coll.Find(bson.M{
		slug: slug,
	}).One(&duff)

	if duff != nil {
		return genUniqSlug(n)
	}

	return slug
}
