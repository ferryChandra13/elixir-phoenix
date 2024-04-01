# lib/my_app_web/live/page_live.ex
defmodule ForumWeb.Live.PageLive do
  use ForumWeb, :live_view

  # Documentation sources
  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Router.html#functions
  # https://www.youtube.com/watch?v=hrpulBR5PFg&t=492s
  # For radar chart, https://medium.com/@lionel.aimerie/integrating-chart-js-into-elixir-phoenix-for-visual-impact-9a3991f0690f
  # https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks-via-phx-hook
  # and GPT tq.
  # mount is the first function to be called (with the default value)
  def mount(_params, _session, socket) do
    talent_forge_user = System.get_env("TALENT_FORGE_USERNAME")
    talent_forge_pass = System.get_env("TALENT_FORGE_PASSWORD")
    HTTPoison.start()
    token = get_token(talent_forge_user, talent_forge_pass)
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json"]
    user_data = get_user_data( 1, headers)
    dept_data = get_department_data( 1, headers)
    {:ok, assign(socket, users: user_data, dept: dept_data), layout: false}
  end

  # When a button with phx-hook="refresh_data" is clicked, handle_event triggered.
  def handle_event("refresh_data", %{"user_id" => user_id, "dept_id" => dept_id}, socket) do
    talent_forge_user = System.get_env("TALENT_FORGE_USERNAME")
    talent_forge_pass = System.get_env("TALENT_FORGE_PASSWORD")
    # can use req library
    HTTPoison.start()
    token = get_token(talent_forge_user, talent_forge_pass)
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
