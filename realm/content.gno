package urlshortenerdemo

import (
	"gno.land/p/demo/btree"
)

type Content struct {
	Key   string
	Value string
}

// Less compares two Content records by their Keys.
func (c Content) Less(than btree.Record) bool {
	other, ok := than.(Content)
	if !ok {
		panic("cannot compare: incompatible types")
	}
	return c.Key < other.Key
}

var _ btree.Record = Content{}

func findShortestNonExistingKey(ds *btree.BTree, bytes []byte, to_store string) string {
	var key string
	for i := 0; i < len(bytes); i++ {
		key += string(bytes[i])
		if ds.Has(Content{Key: key}) {
			value := ds.Get(Content{Key: key})

			if value.(Content).Value == to_store {
				return ""
			}
		} else {
			return key
		}
	}
	return ""
}
