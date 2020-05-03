package cmd

import (
	"bytes"
	"fmt"
	"github.com/mitchellh/mapstructure"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"github.com/yuin/goldmark"
	meta "github.com/yuin/goldmark-meta"
	"github.com/yuin/goldmark/parser"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
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
	Url         string
	Title       string
	Description string
	Tags        []string
	Content     string
}

type Metadata struct {
	Title       string
	Description string
	Tags        []string
}

func syncDirectory(dir string) {
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if !info.IsDir() {
			var url string

			if strings.HasPrefix(path, "/") {
				url = path
			} else {
				url = fmt.Sprintf("/%s", path)
			}

			bs, err := ioutil.ReadFile(path)
			if err != nil {
				return err
			}

			metadata, err := getMetadata(bs)
			if err != nil {
				return err
			}

			var m Metadata

			if err := mapstructure.Decode(metadata, &m); err != nil {
				return err
			}

			f := File{
				Url:     url,
				Content: string(bs),
			}

			if err := applyMetadataToFile(&f, &m, path); err != nil {
				return err
			}

			return nil
		}

		return nil
	})
	exitOnError(err)
}

func getMetadata(bs []byte) (map[string]interface{}, error) {
	md := goldmark.New(goldmark.WithExtensions(meta.Meta))

	var buf bytes.Buffer
	ctx := parser.NewContext()
	if err := md.Convert(bs, &buf, parser.WithContext(ctx)); err != nil {
		return nil, err
	}

	return meta.Get(ctx), nil
}

func applyMetadataToFile(f *File, m *Metadata, path string) error {
	if m.Title == "" {
		return fmt.Errorf("no title provided in %s", path)
	}

	if m.Description != "" {
		f.Description = m.Description
	}

	if m.Tags != nil {
		f.Tags = m.Tags
	}

	return nil
}
