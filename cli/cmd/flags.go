package cmd

import (
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
)

func clientFlags() *pflag.FlagSet {
	flags := pflag.NewFlagSet("client", pflag.ExitOnError)
	flags.StringP("url", "u", Defaults.Url, "GraphQL endpoint URL")
	return flags
}

func docsFlags() *pflag.FlagSet {
	flags := pflag.NewFlagSet("docs", pflag.ExitOnError)
	flags.StringP("dir", "d", Defaults.Dir, "Docs directory")
	return flags
}

func createProjectFlags() *pflag.FlagSet {
	flags := pflag.NewFlagSet("create-project", pflag.ExitOnError)
	flags.StringP("title", "t", "", "Project title")
	flags.StringP("slug", "s", "", "Project slug")
	flags.StringP("description", "d", "", "Project description")
	return flags
}

func bindFlags(cmd *cobra.Command, flags *pflag.FlagSet, v *viper.Viper) {
	cmd.Flags().AddFlagSet(flags)
	exitOnError(v.BindPFlags(flags))
}

func bindPFlags(cmd *cobra.Command, flags *pflag.FlagSet, v *viper.Viper) {
	cmd.PersistentFlags().AddFlagSet(flags)
	exitOnError(v.BindPFlags(flags))
}
