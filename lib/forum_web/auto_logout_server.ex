defmodule Auth.AutoLogoutServer do
  use GenServer
  import Phoenix.Controller

  @inactivity_timeout :timer.seconds(15) # 15 seconds

  def start_link(_opts) do
    IO.puts("AutoLogoutServer has been started.")
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def update_activity(user_id, conn) do
    IO.puts("Update function has been called.")
    GenServer.cast(__MODULE__, {:update_activity, user_id, conn})
  end

  def handle_cast({:update_activity, user_id, conn}, state) do
    IO.puts("Cast function has been called.")
    new_state = start_timer(user_id, state, conn)
    {:noreply, new_state}
  end

  defp start_timer(user_id, state, conn) do
    case Map.get(state, user_id) do
      nil ->
        timer = Process.send_after(self(), {:logout, user_id, conn}, @inactivity_timeout)
        Map.put(state, user_id, timer)

      timer ->
        IO.puts("Timer exists.")
        Process.cancel_timer(timer)
        new_timer = Process.send_after(self(), {:logout, user_id, conn}, @inactivity_timeout)
        Map.put(state, user_id, new_timer)
    end
  end

  def handle_info({:logout, user_id, conn}, state) do
    alias ForumWeb.UserAuth
    # Perform logout logic for the user
    IO.puts("Logging out user due to inactivity")

    new_state = Map.delete(state, user_id)
    conn
    |> UserAuth.log_out_user()
    {:noreply, new_state}
  end
end
