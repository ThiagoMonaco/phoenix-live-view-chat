defmodule ChatWeb.RoomLive do
  alias Chat.Rooms
  alias Chat.Rooms.Room
  alias ChatWeb.Presence
  use ChatWeb, :live_view

  def mount(%{"slug" => slug}, _session, socket) do
    %{current_user: current_user} = socket.assigns
    if connected?(socket) do
      Rooms.join_room(slug, current_user.id, current_user.name)      
    end

    users = Rooms.list_users_room(slug)
    socket =
      socket
      |> assign(:presences, Presence.simple_presence_map(users))
    
    {:ok, socket}
  end

  # defp remove_presences(socket, leaves) do
  #   presences = Presence.map_remove_presences(socket, leaves)
  #   assign(socket, :presences, presences)
  # end
  #
  #
  # defp add_presences(socket, joins) do
  #   presences = Presence.map_add_presences(socket, joins)
  #   assign(socket, :presences, presences)
  # end

  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    IO.inspect(diff, label: "difff")
    socket = 
      socket
      |> remove_presences(diff.leaves)
      |> add_presences(diff.joins)

    {:noreply, socket}
  end

  defp add_presences(socket, joins) do
    Presence.simple_presence_map(joins)
    |> Enum.reduce(socket, fn {user_id, meta}, socket ->
      update(socket, :presences, &Map.put(&1, user_id, meta))
    end)
  end

  defp remove_presences(socket, leaves) do
    Presence.simple_presence_map(leaves)
    |> Enum.reduce(socket, fn {user_id, _}, socket ->
      update(socket, :presences, &Map.delete(&1, user_id))
  end)
end

  def render(assigns) do
    ~H"""
      <div>
        Room 
        <div>
          <div>
            <li :for={{_id, meta} <- @presences}>
              <span class="username">
                <%= meta.name %>
              </span>
            </li>
          </div>
        </div>
      </div>
    """
  end
end
