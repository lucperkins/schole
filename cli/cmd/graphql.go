package cmd

type Errors struct {
	Title []string `json:"title"`
}

type Location struct {
	Column int `json:"column"`
	Line   int `json:"line"`
}

type ErrorRes struct {
	Code      string     `json:"code"`
	Errors    Errors     `json:"errors"`
	Locations []Location `json:"locations"`
	Message   string     `json:"message"`
	Path      []string   `json:"path"`
}
