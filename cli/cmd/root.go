package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"os"
)

func rootCmd() *cobra.Command {
	v := newViper("schole")

	cmd := &cobra.Command{
		Use:   "schole",
		Short: "A headless CMS for technical documentation",
	}

	cmd.AddCommand(docsCmd(v))

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

func newViper(envPrefix string) *viper.Viper {
	v := viper.New()
	v.AutomaticEnv()
	v.SetEnvPrefix(envPrefix)
	return v
}
