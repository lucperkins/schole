package cmd

import (
	"context"
	"errors"
	"github.com/machinebox/graphql"
	"github.com/spf13/viper"
)

type client struct {
	cl  *graphql.Client
	ctx context.Context
}

type project struct {
	ID    string `json:"id"`
	Title string `json:"title"`
	Slug  string `json:"slug"`
}

func newClient(v *viper.Viper) *client {
	url := v.GetString("url")
	ctx := context.Background()

	return &client{
		cl:  graphql.NewClient(url),
		ctx: ctx,
	}
}

func (c *client) listProjects() {
	type response struct {
		Projects []project `json:"findProjects"`
	}

	var res response

	req := graphql.NewRequest(`query { findProjects { id title slug } }`)

	if err := c.cl.Run(c.ctx, req, &res); err != nil {
		exitOnError(err)
	}

	printProjects(res.Projects)
}

func (c *client) createProject(v *viper.Viper) {
	title, slug := v.GetString("title"), v.GetString("slug")

	if title == "" {
		exitOnError(errors.New("must supply a title"))
	}

	type response struct {
		Project project `json:"createProject"`
	}

	var res response

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
		exitOnError(err)
	}

	printProject(res.Project)
}
