package cmd

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	"github.com/gernest/front"
	"github.com/mitchellh/mapstructure"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var allowedExtensions = []string{".md"}

type Document struct {
	ID          string                 `json:"id"`
	Title       string                 `json:"title"`
	Description string                 `json:"description,omitempty"`
	Tags        []string               `json:"tags,omitempty"`
	Content     string                 `json:"content"`
	Metadata    map[string]interface{} `json:"metadata,omitempty"`
}

type Metadata struct {
	Title       string
	Description string
	Tags        []string
	Metadata    map[string]interface{}
}

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
	cl := newClient(v)

	dir := v.GetString("dir")

	cmd := &cobra.Command{
		Use:   "sync",
		Short: "Sync the local docs directory with the Schole API",
		Run: func(_ *cobra.Command, _ []string) {
			errs := syncDirectory(dir, cl)

			if len(errs) > 0 {
				fmt.Println("multiple errors")
			} else {
				fmt.Println("docs successfully synced")
			}
		},
	}

	return cmd
}

func syncDirectory(dir string, cl *client) []error {
	errs := make([]error, 0)

	exitOnError(filepath.Walk(dir, func(path string, info os.FileInfo, _ error) error {
		if !info.IsDir() && hasAllowedExtension(path) {
			doc, err := parseFile(path)
			exitOnError(err)

			cl.createDocument(doc)
		}

		return nil
	}))

	return errs
}

func parseFile(path string) (*Document, error) {
	var meta Metadata

	// Get raw file data
	file, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}

	// Ensure that the file has a front matter delimiter ("---") at the top
	if !strings.HasPrefix(strings.TrimSpace(string(file)), "---") {
		return nil, fmt.Errorf("no document metadata supplied in %s", path)
	}

	// Extract front matter and content
	m := front.NewMatter()
	m.Handle("---", front.YAMLHandler)
	f, body, err := m.Parse(bytes.NewReader(file))
	if err != nil {
		return nil, err
	}

	// Ensure that front matter has been supplied
	if f == nil {
		return nil, fmt.Errorf("no document metadata supplied in %s", path)
	}

	if err := mapstructure.Decode(f, &meta); err != nil {
		return nil, err
	}

	if err := validateMetadata(&meta, path); err != nil {
		return nil, err
	}

	doc := Document{
		Content: body,
	}

	applyMetadataToDoc(&doc, &meta)

	return &doc, nil
}

func applyMetadataToDoc(doc *Document, meta *Metadata) {
	doc.Title = meta.Title

	if meta.Tags != nil {
		doc.Tags = meta.Tags
	}

	if meta.Description != "" {
		doc.Description = meta.Description
	}

	if meta.Metadata != nil {
		doc.Metadata = meta.Metadata
	}
}

func validateMetadata(m *Metadata, path string) error {
	if m.Title == "" {
		return fmt.Errorf("no title provided in file metadata in %s", path)
	}

	return nil
}

func hasAllowedExtension(path string) bool {
	ext := filepath.Ext(path)

	return contains(allowedExtensions, ext)
}

func contains(ss []string, s string) bool {
	for _, i := range ss {
		if i == s {
			return true
		}
	}

	return false
}
