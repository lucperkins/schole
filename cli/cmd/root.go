package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
	"os"
)

func rootCmd() *cobra.Command {
	v := newViper("schole")

	cmd := &cobra.Command{
		Use:   "schole",
		Short: "A headless CMS for technical documentation",
	}

	cmd.AddCommand(projectsCmd(v), docsCmd(v))

	return cmd
}

func Execute() {
	exitOnError(rootCmd().Execute())
}

func exitOnError(err error) {
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}

func clientFlags() *pflag.FlagSet {
	flags := pflag.NewFlagSet("url", pflag.ExitOnError)
	flags.StringP("url", "u", Defaults.Url, "GraphQL endpoint URL")
	return flags
}

func docsFlags() *pflag.FlagSet {
	flags := pflag.NewFlagSet("docs", pflag.ExitOnError)
	flags.StringP("dir", "d", Defaults.Dir, "Docs directory")
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

func newViper(envPrefix string) *viper.Viper {
	v := viper.New()
	v.AutomaticEnv()
	v.SetEnvPrefix(envPrefix)
	return v
}
