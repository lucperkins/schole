package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"github.com/spf13/pflag"
	"github.com/spf13/viper"
	"os"
)

func rootCmd() *cobra.Command {
	//var cfg Config

	v := newViper("schole")

	cmd := &cobra.Command{
		Use: "schole",
		Short: "A headless CMS for technical documentation",
	}

	bindFlags(cmd, v)

	cmd.AddCommand(projectsCmd(v))

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

func bindFlags(cmd *cobra.Command, v *viper.Viper) {
	flags := pflag.NewFlagSet("schole", pflag.ExitOnError)
	flags.StringP("url", "u", Defaults.Url, "GraphQL endpoint URL")

	cmd.Flags().AddFlagSet(flags)
	exitOnError(v.BindPFlags(flags))
}

func newViper(envPrefix string) *viper.Viper {
	v := viper.New()
	v.AutomaticEnv()
	v.SetEnvPrefix(envPrefix)
	return v
}
