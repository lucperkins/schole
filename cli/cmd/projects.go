package cmd

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

type Project struct {
	ID    string
	Title string
	Slug  string
}

type ErrorRes struct {
	Code   string `json:"code"`
	Errors struct {
		Title []string `json:"title"`
	} `json:"errors"`
	Locations []struct {
		Column int `json:"column"`
		Line   int `json:"line"`
	} `json:"locations"`
	Message string   `json:"message"`
	Path    []string `json:"path"`
}

func projectsCmd(v *viper.Viper) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "projects",
		Short: "Manages Schole docs projects",
	}

	bindPFlags(cmd, clientFlags(), v)

	cmd.AddCommand(listProjects(v), createProject(v))

	return cmd
}

func listProjects(v *viper.Viper) *cobra.Command {
	url := v.GetString("url")
	client := NewClient(url)

	cmd := &cobra.Command{
		Use:   "list",
		Short: "List Schole projects",
		Run: func(_ *cobra.Command, _ []string) {
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

	return cmd
}

func createProject(v *viper.Viper) *cobra.Command {
	url := v.GetString("url")
	client := NewClient(url)

	cmd := &cobra.Command{
		Use: "create",
		PreRun: func(_ *cobra.Command, _ []string) {
			if v.GetString("title") == "" {
				exitOnError(errors.New("no title provided"))
			}
		},
		Run: func(_ *cobra.Command, _ []string) {
			type Response struct {
				Data struct {
					CreateProject struct {
						ID string
					}
				}
				Errors []ErrorRes
			}

			var res Response

			mut := fmt.Sprintf("createProject(project:{title:\"%s\"}) { id }",
				v.GetString("title"))
			exitOnError(client.RunMutation(mut, &res))

			if res.Errors != nil {
				js, err := json.Marshal(res.Errors)
				exitOnError(err)

				fmt.Println(string(js))
			} else {
				fmt.Printf("project ID: %s\n", res.Data.CreateProject.ID)
			}
		},
	}

	bindFlags(cmd, createProjectFlags(), v)

	return cmd
}
