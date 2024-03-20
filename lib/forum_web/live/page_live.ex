# lib/my_app_web/live/page_live.ex
defmodule ForumWeb.Live.PageLive do
  use ForumWeb, :live_view

  def mount(_params, _session, socket) do
    HTTPoison.start()
    token = get_token("john.ang", "30971f7a1d2058cebe65e9eb5f50c967bf8fc526a5de9cb8dd42d3ebeec3a938")
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json"]
    user_data = get_user_data( 1, headers)
    dept_data = get_department_data( 1, headers)
    {:ok, assign(socket, users: user_data, dept: dept_data), layout: false}
  end

  # def render(assigns) do
  #   ~L"""
  #   <%= live_render(@socket, ForumWeb.Live.PageLiveView, assigns) %>
  #   """
  # end

  def handle_event("refresh_data", %{"user_id" => user_id, "dept_id" => dept_id}, socket) do
    HTTPoison.start()
    token = get_token("john.ang", "30971f7a1d2058cebe65e9eb5f50c967bf8fc526a5de9cb8dd42d3ebeec3a938")
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json"]
    user_data = get_user_data( user_id, headers)
    dept_data = get_department_data( dept_id, headers)
    {:noreply, assign(socket, users: user_data, dept: dept_data)}
  end

  defp get_user_data(user_id, headers) do
    user_url = "http://127.0.0.1:8001/user/#{user_id}"
    {:ok, user_response} = HTTPoison.get(user_url, headers)
    case Jason.decode(user_response.body) do
      {:ok, data} -> data
    end
  end

  defp get_department_data(dept_id, headers) do
    dept_url = "http://127.0.0.1:8001/dept_members/#{dept_id}"
    {:ok, dept_response} = HTTPoison.get(dept_url, headers)
    case Jason.decode(dept_response.body) do
      {:ok, data} -> data
    end
  end

  defp get_token(username, password) do
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
