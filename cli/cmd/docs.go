package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"io/ioutil"
	"os"
	"path/filepath"
)

func docsCmd(v *viper.Viper) *cobra.Command {
	cmd := &cobra.Command{
		Use:   "docs",
		Short: "Manage Schole docs",
	}

	bindPFlags(cmd, docsFlags(), v)
	bindPFlags(cmd, clientFlags(), v)

	cmd.AddCommand(syncDocs(v))

	return cmd
}

func syncDocs(v *viper.Viper) *cobra.Command {
	dir := v.GetString("dir")

	cmd := &cobra.Command{
		Use:   "sync",
		Short: "Sync the local docs directory with the Schole API",
		Run: func(_ *cobra.Command, _ []string) {
			syncDirectory(dir)
		},
	}

	return cmd
}

type File struct {
	Url     string
	Content string
}

func syncDirectory(dir string) {
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if !info.IsDir() {
			bs, err := ioutil.ReadFile(path)
			if err != nil {
				return err
			}

			f := File{
				Url:     fmt.Sprintf("/%s", path),
				Content: string(bs),
			}

			fmt.Println(f.Content)
		}

		return nil
	})
	exitOnError(err)
}
