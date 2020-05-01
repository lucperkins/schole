# Schole

**Schole** is a [headless CMS][headless] for technical documentation. It enables you to store, update, and query, in one place, all of the information required for documenting an indefinite number of projects—even a whole software ecosystem or all the internal projects for large software org.

The project is in its [early phases](#current-status) and offers pre-alpha versions of a small handful of [data types and operations](#graphql-interface) but will grow over time.

## Running Schole locally

> **Prerequisities**: [Elixir][install] and a recent version of [PostgreSQL].

1. Fetch the repo:

    ```sh
    git clone https://github.com/lucperkins/schole && cd schole
    ```

1. Install dependencies:

    ```sh
    mix deps.get # or make deps
    ```

1. Start up Postgres.
1. Set up the database:

    ```sh
    mix ecto.setup # or make db-setup
    ```

1. Start up Schole:

    ```sh
    mix phx.server # or make run
    ```

1. Explore the [GraphQL Playground][playground] interface at http://localhost:4000/graphql.

### Algolia search

By default, Schole uses [`ilike`](https://www.postgresql.org/docs/current/functions-matching.html#FUNCTIONS-LIKE) in Postgres across documents to provide search. Another option is the SaaS search provider [Algolia](https://algolia.com).

To use Algolia search:

1. Create an Algolia application
1. Set environment variables for the application ID and API key (`ALGOLIA_APPLICATION_ID` and `ALGOLIA_API_KEY`)
1. Comment/uncomment the following in [`config.exs`](config/config.exs):

    ```elixir
    #config :schole, Schole.Search, Schole.Search.Postgres.ILike

    config :schole, Schole.Search, Schole.Search.Algolia

    config :algolia,
      application_id: System.get_env("ALGOLIA_APPLICATION_ID"),
      api_key: System.get_env("ALGOLIA_API_KEY")
    ```

## The problem that Schole solves

There are plenty of good tools out there for creating and publishing documentation *for a single project*. In most cases, putting all of your docs into a single repository and using a tool like [Jekyll] or [Hugo] or [Sphinx] is perfectly sufficient.

But this approach runs into hard limits when your needs extend beyond the single project level. Here are some scenarios that require something different:

* You want to organize information for an entire software ecosystem consisting of many projects (imagine a single data interface for an ecosystem like [Kubernetes], [Kafka], or [Hadoop])
* You're in a large org with many internal docs projects but want information to be shareable between them (imagine you're running a company like [VMWare] or [Twitter] and want a centralized doc content system for all of your internal projects)
* Some set of information needs a single source of truth that downstream docs projects can rely on (e.g. which features are currently deprecated, alpha, beta, etc.)

## How Schole thinks about information

Schole provides a single, centralized storage system for *all* of the information associated with an *indefinite number* of software projects. This information currently includes only one type of data: Markdown documents and the associated metadata and tags. But Schole can in principle expand to support all kinds of data, such as release notes, changelogs, arbitrary key/value info, concept lists, FAQs, event info, community and social media links, [OpenAPI] specs, [Protocol Buffers][protobuf] documentation, language-specific API docs, and so on.

### GraphQL interface

All Schole data is accessible via a [GraphQL] interface that enables you to run queries like this:

```graphql
query {
  findProject(slug: "my-docs-project") {
    title
    description
    metadata
    documents {
      title
      tags
      content
    }
  }
}
```

This `findProject` query would return some project-level info for `my-docs-project` as well as the documents associated with the project as a single JSON object. That information could be used, for example, by a [Gatsby] theme to build the project website.

If you wanted to create a landing page for all of your projects, you could use a query like this:

```graphql
query {
  projects {
    title
    description
    slug
  }
}
```

### Full interface definition

The GraphQL interface provided by Schole is defined in [`schema.graphql`](./schema.graphql).

## Data layer vs. view layer

Schole is a "headless" CMS because it doesn't (yet) provide a view layer; it's just a content backend that's meant to provide data inputs to tools that *can* provide a view. These tools include:

* Next-gen static site generators like [Gatsby] and [Gridsome] that are purpose-built to take data inputs from a wide variety of sources, including but not limited to [GraphQL] APIs like Schole.
* Traditional static site generators like Jekyll or Hugo used in conjunction with a data-fetching tool like [Sourcebit] or some kind of scripting setup.

> In the future, I plan to provide a default view layer for Schole, possibly a Gatsby or Gridsome theme. Stay tuned.

### Data/view separation scenario

The separation between data and view is extremely important because it allows information to be synced across any number of downstream consumers. Imagine that a software ecosystem surrounding a database called **SuperStore** is using Schole; that ecosystem consists of 25 separate docs projects, some of which are devoted to language clients, some to CLI tools, some to DevOps, etc. Out of these 25 projects, 10 need to know which of SuperStore's features are currently considered alpha, beta, production ready, or deprecated.

With Schole, you could potentially expose a `Feature` data type and a `getFeature` query that would enable all docs projects in the ecosystem to fetch that information like this:

```graphql
query {
  getFeature(slug: "geo-replication") {
    name
    description
    currentStatus {
      status
      since
    }
    relatedFeatures {
      name
    }
  }
}
```

Now, when you change the status of, say, the `geo-replication` feature from `alpha` to `beta`, all downstream projects can reflect that change because they're relying on a single data source. And you don't even need to know which projects require that info.

## Architecture

Schole is built in [Elixir] using the [Absinthe] library for [GraphQL]. It uses [PostgreSQL] as a database.

For search, Schole uses very simple [`ilike`][ilike] queries

## Current status

Schole is currently not *quite* vaporware but pretty close. I'm building it and throwing it out there mostly to provoke discussion and to elicit feedback on how people might use it. I suspect that many people in our industry, even those whose bread and butter is documentation, haven't thought through the potential benefits of having a centralized content interface like Schole. What I've provided initially here is hopefully enough to get people curious about where it could go next.

I've chosen a tech ["stack"](#architecture) geared toward speedy development, so I hope to see the project grow quickly.

### Near-term goals

* Better Postgres-based search using [`tsvector`][tsvector] and extensions.
* A command line tool that enables you to, for example, sync a local directory of documents with Schole.
* Some kind of simple authentication system that's an improvement on "everything is public!" Maybe basic auth or an API key system.

### Longer-term aspirations

* Move search to an index-based system like [Elasticsearch].
* Integration with other data sources, like Google Docs, [Confluence], etc.
* An authorization system that, for example, enables some users to create/read/update/delete, and others to only read.

## FAQ

#### How does data go into Schole?

Right now the only way to put data into Schole is to use the [GraphQL Playground][playground] interface that ships with it or to make raw GraphQL calls to the server using the GraphQL Playground UI or a GraphQL client.

Eventually I'd like to improve this story dramatically by providing a CLI tool that makes data ingestion much easier and even allows for things like uploading entire directories of documents, modifying a single piece of key/value information, or uploading JSON or YAML. Also not out of the question: an in-browser WYSIWYG editor.

#### Where is version control in all of this?

Nowadays, most documentation projects handle documentation "state" via version control systems like [Git]. Schole is meant to provide a new source of truth for documentation that lives at a higher level than the single repo.

*But* that doesn't mean that version control is simply out of the picture. I'd like to provide tools that enable you to do things like syncing a `docs` directory in a repo with Schole every time you push to `master`.

#### So you're basically just storing docs in a database. Why is that interesting?

I know, right? Not really radical or pathbreaking at all. But I do think that we need a fresh approach to this set of problems and I don't see a path forward that doesn't involve a database and a unified data interface.

#### How can I contribute?

Issues and pull requests welcome! That includes feature suggestions.

[absinthe]: https://hexdocs.pm/absinthe/overview.html
[confluence]: https://www.atlassian.com/software/confluence
[elasticsearch]: https://www.elastic.co/elasticsearch
[elixir]: https://elixir-lang.com
[gatsby]: https://gatsbyjs.org
[gridsome]: https://gridsome.org
[git]: https://git-scm.com
[graphql]: https://graphql.org
[hadoop]: https://hadoop.apache.org
[headless]: https://headlesscms.org/about
[hugo]: https://gohugo.io
[ilike]: https://www.postgresql.org/docs/12/functions-matching.html
[install]: https://elixir-lang.org/install.html
[jekyll]: https://jekyll-rb.com
[kafka]: https://kafka.apache.org
[kubernetes]: https://kubernetes.io
[openapi]: https://www.openapis.org
[playground]: https://github.com/prisma-labs/graphql-playground
[postgresql]: https://postgresql.org
[protobuf]: https://developers.google.com/protocol-buffers
[sourcebit]: https://github.com/stackbithq/sourcebit
[sphinx]: https://www.sphinx-doc.org
[tsvector]: https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search
[twitter]: https://twitter.com
[vmware]: https://vmware.com
