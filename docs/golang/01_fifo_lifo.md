## FIFO(first in, first out. e.g. queue)

golang 的chan是一个比较典型的fifo
```go
// $GOROOT/src/runtime/chan.go
type waitq struct {
	first *sudog
	last  *sudog
}

func (q *waitq) enqueue(sgp *sudog) {
	sgp.next = nil
	x := q.last
	if x == nil {
		sgp.prev = nil
		q.first = sgp
		q.last = sgp
		return
	}
	sgp.prev = x
	x.next = sgp
	q.last = sgp
}

func (q *waitq) dequeue() *sudog {
	for {
		sgp := q.first
		if sgp == nil {
			return nil
		}
		y := sgp.next
		if y == nil {
			q.first = nil
			q.last = nil
		} else {
			y.prev = nil
			q.first = y
			sgp.next = nil // mark as removed (see dequeueSudog)
		}

		// if sgp participates in a select and is already signaled, ignore it
		if sgp.selectdone != nil {
			// claim the right to signal
			if *sgp.selectdone != 0 || !cas(sgp.selectdone, 0, 1) {
				continue
			}
		}

		return sgp
	}
}


```

## LIFO(last in, first out. e.g. stack)

  - [slices usage](http://blog.golang.org/go-slices-usage-and-internals)
  - [slices example](https://github.com/yubo/program/blob/master/go/example/56_slice_array.go)

```go
// $GOROOT/src/runtime/race/testdata/regression_test.go
type stack []int

func (s *stack) push(x int) {
	*s = append(*s, x)
}

func (s *stack) pop() int {
	i := len(*s)
	n := (*s)[i-1]
	*s = (*s)[:i-1]
	return n
}
```
