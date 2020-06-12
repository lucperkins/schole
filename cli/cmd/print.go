package cmd

import (
	"github.com/jedib0t/go-pretty/table"
)

func buildWriter(title string, header table.Row) table.Writer {
	tw := table.NewWriter()
	tw.SetTitle(title)
	tw.AppendHeader(header)
	return tw
}
