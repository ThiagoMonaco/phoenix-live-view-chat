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

  defp remove_presences(socket, leaves) do
    presences = Presence.map_remove_presences(socket, leaves)
    assign(socket, :presences, presences)
  end


  defp add_presences(socket, joins) do
    presences = Presence.map_add_presences(socket, joins)
    assign(socket, :presences, presences)
  end

  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    socket = 
      socket
      |> remove_presences(diff.leaves)
      |> add_presences(diff.joins)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        room
        <div>
          <div>
            <li :for={{id, meta} <- @presences} :if={id != @current_user.id}>
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
