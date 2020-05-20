package cmd

import (
	"fmt"
	"github.com/jedib0t/go-pretty/table"
)

var projectsHeader = table.Row{"id", "title", "slug"}

func printProjects(ps []project) {
	t := buildWriter("created project", projectsHeader)

	for _, p := range ps {
		t.AppendRow(table.Row{p.ID, p.Title, p.Slug})
	}

	fmt.Println(t.Render())
}

func printProject(p project) {
	t := buildWriter("created project", projectsHeader)
	t.AppendRow(table.Row{p.ID, p.Title, p.Slug})
	fmt.Println(t.Render())
}

func buildWriter(title string, header table.Row) table.Writer {
	tw := table.NewWriter()
	tw.SetTitle(title)
	tw.AppendHeader(header)
	return tw
}
