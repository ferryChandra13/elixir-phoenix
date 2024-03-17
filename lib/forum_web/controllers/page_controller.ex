defmodule ForumWeb.PageController do
  use ForumWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def users(conn, _params) do
    users = [
      %{id: 1, name: "Alice", email: "LsS3M@example.com"},
      %{id: 2, name: "Bob", email: "3wPpF@example.com"},
      %{id: 3, name: "Eve", email: "5i8wv@example.com"},
    ]
    # render(conn, :users, users: users, layout: false)
    json(conn, %{users: users})
  end
end
