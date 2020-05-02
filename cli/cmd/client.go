package cmd

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"time"
)

type Client struct {
	url     string
	timeout time.Duration
}

func NewClient(url string) *Client {
	return &Client{
		url:     url,
		timeout: 10 * time.Second,
	}
}

func (c *Client) RunQuery(query string, obj interface{}) error {
	q := []byte(fmt.Sprintf("query { %s }", query))

	req, err := http.NewRequest(http.MethodPost, c.url, bytes.NewBuffer(q))
	if err != nil {
		return err
	}

	cl := &http.Client{Timeout: c.timeout}
	res, err := cl.Do(req)
	if err != nil {
		return err
	}

	defer res.Body.Close()

	data, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return err
	}

	return json.Unmarshal(data, obj)
}
