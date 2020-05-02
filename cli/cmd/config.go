package cmd

type Config struct {
	Url string
	Dir string
}

var Defaults = struct {
	Url string
	Dir string
}{
	"http://localhost:4000/graphql",
	"docs",
}

func (c *Config) Validate() error {
	if c.Url == "" {
		return ErrNoUrl
	}

	return nil
}
