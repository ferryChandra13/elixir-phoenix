defmodule ForumWeb.SkillController do
  use ForumWeb, :controller

  def department_member(conn, %{"user_id" => user_id}) do
    HTTPoison.start()
    token = get_token("john.ang", "30971f7a1d2058cebe65e9eb5f50c967bf8fc526a5de9cb8dd42d3ebeec3a938")
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json"]
    user_data = get_user_data(conn, user_id, headers)
    dept_data = get_department_data(conn, 1, headers)
    IO.inspect(dept_data)
    render(
      conn,
      :member,
      users: user_data,
      dept: dept_data,
      layout: false
    )
  end

  defp get_user_data(conn, user_id, headers) do
    HTTPoison.start()
    user_url = "http://127.0.0.1:8001/user/#{user_id}"
    {:ok, user_response} = HTTPoison.get(user_url, headers)
    case Jason.decode(user_response.body) do
      {:ok, data} -> data
      {:error, _error} ->
        # Handle the error, e.g., send an error response or log the error
        send_resp(conn, 500, "Internal server error")
    end
  end

  defp get_department_data(conn, dept_id, headers) do
    HTTPoison.start()
    dept_url = "http://127.0.0.1:8001/dept_members/#{dept_id}"
    {:ok, dept_response} = HTTPoison.get(dept_url, headers)
    case Jason.decode(dept_response.body) do
      {:ok, data} -> data
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
