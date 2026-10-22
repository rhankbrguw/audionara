package usecase

import "sync"

type streamCall struct {
	wg  sync.WaitGroup
	val string
	err error
}

// StreamFlightGroup deduplicates in-flight audio stream resolution requests.
type StreamFlightGroup struct {
	mu sync.Mutex
	m  map[string]*streamCall
}

// NewStreamFlightGroup creates a new deduplication coordinator.
func NewStreamFlightGroup() *StreamFlightGroup {
	return &StreamFlightGroup{m: make(map[string]*streamCall)}
}

// Do executes fn once for a given key, sharing the result with concurrent callers.
func (g *StreamFlightGroup) Do(key string, fn func() (string, error)) (string, error) {
	g.mu.Lock()
	if c, ok := g.m[key]; ok {
		g.mu.Unlock()
		c.wg.Wait()
		return c.val, c.err
	}
	c := new(streamCall)
	c.wg.Add(1)
	g.m[key] = c
	g.mu.Unlock()

	c.val, c.err = fn()
	c.wg.Done()

	g.mu.Lock()
	delete(g.m, key)
	g.mu.Unlock()

	return c.val, c.err
}
