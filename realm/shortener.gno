package urlshortenerdemo

import (
	"crypto/sha256"
	"encoding/base64"

	"gno.land/p/demo/btree"
)

// We'll store code->URL mappings in a BTree.
var store = btree.New()

// Shorten a URL and return a short code, or `#` if there is an error.
func Shorten(url string) string {
	hash := sha256.Sum256([]byte(url))
	hashBytes := hash[:]
	buffer := make([]byte, base64.RawURLEncoding.EncodedLen(len(hashBytes)))
	base64.RawURLEncoding.Encode(buffer, hashBytes)
	code := findShortestNonExistingKey(store, buffer, url)

	if code == "" {
		return "#"
	}

	store.Insert(Content{Key: code, Value: url})
	return code
}

// Render returns the full URL based on the shortcode, or `#` if the code doesn't match a URL.
func Render(code string) string {
	data := store.Get(Content{Key: code})
	if data != nil {
		return data.(Content).Value
	}

	return "#"
}
