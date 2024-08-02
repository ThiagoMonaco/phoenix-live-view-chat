defmodule ChatWeb.RoomLive do
  alias Chat.Rooms
  alias Chat.Rooms.Room
  use ChatWeb, :live_view

  def mount(%{"slug" => slug}, _session, socket) do
    %{current_user: current_user} = socket.assigns
    if connected?(socket) do
      Rooms.join_room(slug, current_user.id, current_user.name)      
    end

    users = Rooms.list_users_room(slug)
    socket =
      socket
      |> assign(:users, slug)
    
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
        room
      </div>
    """
  end
end
