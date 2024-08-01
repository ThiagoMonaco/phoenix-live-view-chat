defmodule ChatWeb.DashboardLive do
  alias Chat.Rooms.Room
  alias Chat.Rooms
  use ChatWeb, :live_view

  alias ChatWeb.Presence

  @topic_users_online "users:connected"

  def mount(_params, _session, socket) do
    %{current_user: current_user} = socket.assigns

    if connected?(socket) do
      Phoenix.PubSub.subscribe(Chat.PubSub, @topic_users_online)
      {:ok, _} = Presence.track(self(), @topic_users_online, current_user.id, %{
        name: current_user.name
      })

      Rooms.subscribe()
    end

    presences = Presence.list(@topic_users_online)
    
    rooms = Rooms.list_rooms()
    socket =
      socket
      |> stream(:rooms, rooms)
      |> assign(:presences, simple_presence_map(presences))

    {:ok, socket}
  end

  def simple_presence_map(presences) do
    Enum.into(presences, %{}, fn {user_id, %{metas: [meta | _]}} -> 
      {user_id, meta}
    end)
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
  
  def handle_event("create_room", _, socket) do
    %{current_user: current_user} = socket.assigns
    # Phoenix.PubSub.broadcast(Chat.PubSub, @topic_rooms, )
    Rooms.create_room("nomepadrao", current_user.id)
    {:noreply, socket}
  end

  def handle_info({:room_created, room}, socket) do
    {:noreply, stream_insert(socket, :rooms, room, at: 0)}
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
        <h1>Dashboard</h1>
        <li :for={{_, meta} <- @presences}>
            <span class="username">
              <%= meta.name %>
            </span>
          </li>
          <.button phx-click="create_room">
            Create Room
          </.button>
      </div>
    """
  end
end
