defmodule ForumWeb.PageController do
  alias Forum.Repo
  alias Forum.Accounts.User
  use ForumWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    users = Repo.all(User)
    render(conn, :home, users: users, layout: false)
  end

  # def users(conn, _params) do
  #   users = [
  #     %{id: 1, name: "Alice", email: "LsS3M@example.com"},
  #     %{id: 2, name: "Bob", email: "3wPpF@example.com"},
  #     %{id: 3, name: "Eve", email: "5i8wv@example.com"},
  #   ]
  #   # render(conn, :users, users: users, layout: false)
  #   json(conn, %{users: users})
  # end

  def get_skills(conn, %{"user_id" => user_id}) do
    HTTPoison.start()
    url = "http://127.0.0.1:8001/getskills/#{user_id}"
    token = get_token("john.ang", "30971f7a1d2058cebe65e9eb5f50c967bf8fc526a5de9cb8dd42d3ebeec3a938")
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json"]
    {:ok, response} = HTTPoison.get(url, headers)
    case Jason.decode(response.body) do
      {:ok, data} ->
        json(conn, %{skills: data})
      {:error, _error} ->
        # Handle the error, e.g., send an error response or log the error
        send_resp(conn, 500, "Internal server error")
    end
  end

  defp get_token(username, password) do
    HTTPoison.start()
    url = "http://127.0.0.1:8001/token"
    body = {:form, [username: username, password: password]}
    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]
    {:ok, response} = HTTPoison.post(url, body, headers)

    case Jason.decode(response.body) do
      {:ok, data} -> data["accessToken"]
      {:error, _} -> {:error, "Failed to get token"}
    end
  end
end
