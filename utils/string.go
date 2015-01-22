package utils

import (
	"math/rand"
)

var chars = []rune("abcdefghijklmnopqrstuvwxyz01234567ABCDEFGHIJKLMNOPQRSTUVWXYZ")

func RandSeq(n int) string {
	i, l := 0, len(chars)
	b := make([]rune, n)
	for i < n {
		b[i] = chars[rand.Intn(l)]
		i++
	}
	return string(b)
}

func Split(s, d string) []string {
	var i, c, n int

	l := len(s)

	for i < l {
		if s[i:i+1] == d {
			c++
		}
		i++
	}

	a := make([]string, c+1)
	c, i = 0, 0

	for i < l {
		if i == l-1 {
			a[c] = s[n : i+1]
			break
		}
		if s[i:i+1] == d {
			a[c] = s[n:i]
			n = i + 1
			c++
		}
		i++
	}

	return a
}
