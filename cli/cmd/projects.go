package cmd

import (
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

	bindPFlags(cmd, clientFlags(), v)

	cmd.AddCommand(
		listProjects(v),
		createProject(v))

	return cmd
}

func listProjects(v *viper.Viper) *cobra.Command {
	cl := newClient(v)

	cmd := &cobra.Command{
		Use:   "list",
		Short: "List Schole projects",
		Run: func(_ *cobra.Command, _ []string) {
			exitOnError(cl.listProjects())
		},
	}

	return cmd
}

func createProject(v *viper.Viper) *cobra.Command {
	cl := newClient(v)

	cmd := &cobra.Command{
		Use:   "create",
		Short: "Create a new Schole docs project",
		Run: func(_ *cobra.Command, _ []string) {
			exitOnError(cl.createProject(v))
		},
	}

	bindFlags(cmd, createProjectFlags(), v)

	return cmd
}
