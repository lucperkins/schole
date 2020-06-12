package cmd

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
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

func (c *client) createDocument(doc *Document) {
	type response struct {
		Document Document `json:"CreateDocument"`
	}

	var res response

	req := graphql.NewRequest(`mutation CreateDocument($title:String!,$description:String,$content:String!,$tags:[String],$metadata:Json) {
		createDocument(document:{title:$title,description:$description,content:$content,tags:$tags,metadata:$metadata}) {
			id title description content tags metadata
		}
	}`)

	req.Var("title", doc.Title)
	req.Var("description", doc.Description)
	req.Var("content", doc.Content)
	req.Var("tags", doc.Tags)

	if doc.Metadata != nil {
		bs, err := json.Marshal(doc.Metadata)
		exitOnError(err)

		req.Var("metadata", string(bs))
	}

	if err := c.cl.Run(c.ctx, req, &res); err != nil {
		exitOnError(err)
	}

	fmt.Println(res.Document.ID)
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
