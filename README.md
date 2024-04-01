# Forum

Start PostgreSQL server,

- Run `docker pull postgres` to pull the latest image
- Run `docker run --name postgres-elixir -e POSTGRES_PASSWORD=postgres -d -p 5433:5432 postgres:latest` to start the server

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Run `npm install chart.js --save` to install radar chart
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
