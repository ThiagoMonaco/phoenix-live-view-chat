defmodule ChatWeb.DashboardLive do
  use ChatWeb, :live_view

  alias ChatWeb.Presence

  @topic "users:connected"
  def mount(_params, _session, socket) do
    %{current_user: current_user} = socket.assigns

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Chat.PubSub, @topic)
      {:ok, _} = Presence.track(self(), @topic, current_user.id, %{
        name: current_user.name
      })
    end

    presences = Presence.list(@topic)
    {:ok, assign(socket, presences: simple_presence_map(presences))}
  end

  def simple_presence_map(presences) do
    Enum.into(presences, %{}, fn {user_id, %{metas: [meta | _]}} -> 
      {user_id, meta}
    end)
  end

  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    socket = 
      socket
      |> remove_presences(diff.leaves)
      |> add_presences(diff.joins)

    IO.inspect("mesgagemoigao")
    {:noreply, socket}
  end

  defp remove_presences(socket, leaves) do
    user_ids = Enum.map(leaves, fn {user_id, _} -> user_id end)

    presences = Map.drop(socket.assigns.presences, user_ids)

    assign(socket, :presences, presences)
  end


  defp add_presences(socket, joins) do
    presences = Map.merge(socket.assigns.presences, simple_presence_map(joins)) 
    assign(socket, :presences, presences)
  end

  def render(assigns) do
    ~H""" 
      <div>
        <h1>Dashboard</h1>
        <li :for={{_, meta} <- @presences}>
            <span class="username">
              <%= meta.name %>
            </span>
          </li>
      </div>
    """
  end
end
