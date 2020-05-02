package cmd

import (
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func projectsCmd(v *viper.Viper) *cobra.Command {
	cmd := &cobra.Command{
		Use: "projects",
		Short: "Manages Schole docs projects",
	}

	bindFlags(cmd, v)

	cmd.AddCommand(createProject(v))

	return cmd
}

func createProject(v *viper.Viper) *cobra.Command {
	cmd := &cobra.Command{
		Use: "create",
		Short: "Create a new Schole project",
		Run: func(_ *cobra.Command, _ []string) {
			println(v.GetString("url"))
			println("creating project...")
		},
	}

	bindFlags(cmd, v)

	return cmd
}
