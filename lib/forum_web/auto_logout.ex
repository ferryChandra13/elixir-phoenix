defmodule Auth.AutoLogout do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns.current_user do
      nil ->
        conn

      user_id ->
        Auth.AutoLogoutServer.start_link([])
        Auth.AutoLogoutServer.update_activity(user_id, conn)
        conn
    end
  end

  defp current_time, do: System.system_time(:millisecond)
end
