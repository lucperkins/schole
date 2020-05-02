package cmd

type Config struct {
	Url string
}

var Defaults = struct {
	Url string
}{
	"http://localhost:4000/graphql",
}

func (c *Config) Validate() error {
	if c.Url == "" {
		return ErrNoUrl
	}

	return nil
}
