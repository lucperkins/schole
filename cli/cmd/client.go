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
	q := fmt.Sprintf("query { %s }", query)

	return c.run(q, obj)
}

func (c *Client) RunMutation(mutation string, obj interface{}) error {
	q := fmt.Sprintf("mutation { %s }", mutation)

	return c.run(q, obj)
}

func (c *Client) run(query string, obj interface{}) error {
	bs := bytes.NewBuffer([]byte(query))

	req, err := http.NewRequest(http.MethodPost, c.url, bs)
	if err != nil {
		return err
	}

	cl := &http.Client{Timeout: c.timeout}
	res, err := cl.Do(req)
	if err != nil {
		return err
	}

	defer res.Body.Close()

	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return err
	}

	return json.Unmarshal(body, obj)
}
