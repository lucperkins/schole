package cmd

import (
	"context"
	"encoding/json"

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

func (c *client) createDocument(doc *Document) {
	type response struct {
		Document Document `json:"CreateDocument"`
	}

	var res response

	req := graphql.NewRequest(`mutation CreateDocument($title:Stringq!,$description:String,$content:String!,$tags:[String],$metadata:Json) {
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
}
