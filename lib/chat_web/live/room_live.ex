defmodule ChatWeb.RoomLive do
  alias ChatWeb.ChatBoxLive
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
      |> assign(:slug, slug)
    
    {:ok, socket}
  end

  defp remove_presences(socket, leaves) do
    presences = Presence.map_remove_presences(socket, leaves)
    IO.inspect(presences, label: "removeuuu")
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

  def handle_info({:created_message, message}, socket) do
    Rooms.send_message(socket.assigns.slug, message)
    {:noreply, socket}
  end

  def handle_info({:message_send, message}, socket) do
    send_update(ChatBoxLive, new_message: message, id: :chat_box)
    {:noreply, socket}
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
          <.live_component module={ChatBoxLive} id={:chat_box} current_user={@current_user}/>
        </div>
      </div>
    """
  end
end
