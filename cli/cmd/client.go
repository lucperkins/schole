package cmd

import (
	"context"
	"errors"
	"fmt"
	"github.com/machinebox/graphql"
	"github.com/spf13/viper"
)

type client struct {
	cl  *graphql.Client
	ctx context.Context
}

func newClient(v *viper.Viper) *client {
	url := v.GetString("url")
	ctx := context.Background()

	return &client{
		cl:  graphql.NewClient(url),
		ctx: ctx,
	}
}

func (c *client) listProjects() error {
	type resp struct {
		FindProjects []struct {
			ID    string `json:"id"`
			Title string `json:"title"`
			Slug  string `json:"slug"`
		}
	}

	var res resp

	req := graphql.NewRequest(`query { findProjects { id title slug } }`)

	if err := c.cl.Run(c.ctx, req, &res); err != nil {
		return err
	}

	fmt.Println(res)

	return nil
}

func (c *client) createProject(v *viper.Viper) error {
	title, slug := v.GetString("title"), v.GetString("slug")
	if title == "" {
		return errors.New("must supply a title")
	}

	type resp struct {
		CreateProject struct {
			ID    string `json:"id"`
			Slug  string `json:"slug"`
			Title string `json:"title"`
		}
	}

	var res resp

	req := graphql.NewRequest(`mutation ($title: String!, $slug: String) {
		createProject(project: {title: $title, slug: $slug}) {
			id slug title
		}
	}`)

	req.Var("title", title)

	if slug != "" {
		req.Var("slug", slug)
	}

	if err := c.cl.Run(c.ctx, req, &res); err != nil {
		return err
	}

	fmt.Println(res)

	return nil
}
