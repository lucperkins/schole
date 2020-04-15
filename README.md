# Schole

**Schole** is a [headless CMS](https://headlesscms.org/about) for technical documentation.

## Running Schole locally

> **Prerequisities**: [Elixir](https://elixir-lang.org/install.html) and a recent version of [PostgreSQL](https://postgresql.org).

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

1. Explore the [GraphQL Playground](https://github.com/prisma-labs/graphql-playground) interface at http://localhost:4000/graphql.

## The problem that Schole solves

There are plenty of good tools out there for creating and publishing documentation *for a single project*. In most cases, putting all of your docs into a single repository and using a tool like [Jekyll](https://jekyll-rb.com) or [Hugo](https://gohugo.io) or [Sphinx](https://www.sphinx-doc.org) is perfectly sufficient.

But this approach runs into hard limits when your needs extend beyond the single project. Scenarios like this require something different:

* You want to synchronize information for an entire software ecosystem with many projects
* You're in a large org with many internal docs projects but want information to be shareable between them

## How Schole thinks about information

Schole provides a single, centralized storage system for *all* of the information associated with an indefinite number of software projects. This information currently includes only one type of data: Markdown documents. But Schole could expand to support all kinds of data, such as release notes, changelogs, arbitrary key/value info, concept lists, FAQs, event info, community and social media links, [OpenAPI](https://www.openapis.org) specs, and so on.

### GraphQL interface

All Schole data is accessible via a [GraphQL](https://graphql.org) interface that enables you to run queries like this:

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

This `findProject` query would return the project info for `my-docs-project` as well as the documents associated with the project as a single JSON object. That information could be used by, for example, a [Gatsby](https://gatsbyjs.org) theme to build the project website.

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

## Data layer vs. view layer

Schole is a "headless" CMS because it doesn't (yet) provide a view layer; it's just a data backend that's meant to provide data inputs to tools that *can* provide a view. These tools include:

* Next-gen static site generators like [Gatsby](https://gatsbyjs.org) and [Gridsome](https://gridsome.org) that are purpose-built to take data inputs from a wide variety of sources, including but not limited to [GraphQL](https://graphql.org) APIs like Schole.
* Traditional static site generators like Jekyll or Hugo used in conjunction with a data-fetching tool like [Sourcebit](https://github.com/stackbithq/sourcebit).

> In the future, I plan to provide a default view layer for Schole, possibly a Gatsby theme. Stay tuned.

### Data/view separation scenario

The separation between data and view is extremely important because it allows information to be synced across any number of downstream consumers. Imagine that a software ecosystem surrounding a database called SuperStore is using Schole; that ecosystem consists of 25 separate docs projects, some of which are devoted to language clients, some to CLI tools, some to DevOps, etc. Out of these 25 projects, 10 need to know the status of SuperStore's main features are currently considered alpha, beta, production ready, or deprecated.

With Schole, you could potentially expose a features data type that would enable all projects in the ecosystem to fetch that information like this:

```graphql
query {
  features(projectId: 20) {
    name
    status
  }
}
```

Now, when you change the status of, say, the `tiered-storage` feature from `alpha` to `beta`, all downstream projects can reflect that change because they're relying on a single data source.

## Current status

Schole is currently not *quite* vaporware but pretty close. I'm building it and throwing it out there mostly to provoke discussion and to elicit feedback on how people might use it.

I've chosen a tech ["stack"](#tech-stack) geared toward speedy development, so I hope to see the project grow quickly.

## Tech stack

Schole is built in [Elixir](https://elixir-lang.com) using the [Phoenix](https://phoenixframework.org) web framework and the [Absinthe](https://hexdocs.pm/absinthe/overview.html) library for [GraphQL](https://graphql.org). It uses [PostgreSQL](https://postgresql.org) as a database.

## FAQ

#### How does data go into Schole?

Right now the only way to put data into Schole is to use the [GraphQL Playground](https://github.com/prisma-labs/graphql-playground) interface that ships with it or to make raw GraphQL calls to the server using a GraphQL client.

Eventually I'd like to improve this story dramatically by providing a CLI tool that makes data ingestion much easier and even allows for things like uploading entire directories of documents, modifying single bit of key/value information, or uploading JSON or YAML. Also not out of the question: an in-browser WYSIWYG editor.

#### Where is version control in all of this?

Nowadays, many documentation projects handle documentation "state" via version control systems like [Git](https://git-scm.com). Schole is meant to provide a new source of truth for documentation that lives at a higher level than the single repo.

*But* that doesn't mean that version control is simply out of the picture. I'd like to provide tools that enable you to do things like syncing a `docs` directory in a repo with Schole every time you push to `master`.

#### So you're basically just storing docs in a database. Why is that interesting?

I know, right? Not really radical or pathbreaking at all. But I do think that we need a fresh approach to this set of problems.

#### How can I contribute?

Issues and pull requests welcome! That includes feature suggestions.
