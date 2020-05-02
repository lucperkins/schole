package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

type Project struct {
	ID    string
	Title string
	Slug  string
}

func projectsCmd(v *viper.Viper) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "projects",
		Short: "Manages Schole docs projects",
	}

	bindFlags(cmd, v)

	cmd.AddCommand(listProjects(v))

	return cmd
}

func listProjects(v *viper.Viper) *cobra.Command {
	url := v.GetString("url")

	cmd := &cobra.Command{
		Use:   "list",
		Short: "List Schole projects",
		Run: func(_ *cobra.Command, _ []string) {
			client := NewClient(url)

			q := `findProjects { id title slug }`

			type Response struct {
				Data struct {
					FindProjects []Project
				}
			}

			var res Response

			exitOnError(client.RunQuery(q, &res))

			for _, p := range res.Data.FindProjects {
				fmt.Printf("id: %s, title: %s, slug: %s\n", p.ID, p.Title, p.Slug)
			}
		},
	}

	bindFlags(cmd, v)

	return cmd
}
