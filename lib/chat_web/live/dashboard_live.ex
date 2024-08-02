defmodule ChatWeb.DashboardLive do
  alias Phoenix.Presence
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

    changeset = Room.changeset(%Room{}, %{})

    presences = Presence.list(@topic_users_online)
    
    rooms = Rooms.list_rooms()
    socket =
      socket
      |> stream(:rooms, rooms)
      |> assign(:form, to_form(changeset))
      |> assign(:presences, Presence.simple_presence_map(presences))

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
  
  def handle_event("create_room", %{"room" => params}, socket) do
    %{current_user: current_user} = socket.assigns
    Rooms.create_room(params["name"], current_user.id)

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
        <div>
        <li :for={{id, meta} <- @presences} :if={id != @current_user.id}>
          <span class="username">
            <%= meta.name %>
          </span>
        </li>
        </div>
        <div phx-update="stream" id="rooms">
          <li :for={{_, meta} <- @streams.rooms}>
            <span class="username">
              <%= meta.name %>
            </span>
            <.link patch={~p"/room/#{meta.slug}"} >
              Join <%= meta.slug %>
            </.link>
          </li>
        </div>
       
       <.form
        for={@form}
        phx-submit="create_room"
       >
        <.input phx-debounce="blur" field={@form[:name]} label="Name" required />
         <.button>
           Create Room
         </.button>
       </.form>
      </div>
    """
  end
end
