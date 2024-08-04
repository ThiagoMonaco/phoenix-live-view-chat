defmodule ChatWeb.ChatBoxLive do
  alias Ecto.UUID
  alias Chat.ChatMessage
  use ChatWeb, :live_component

  def mount(socket) do
    form = ChatMessage.changeset(%ChatMessage{}, %{})

    socket = 
      socket
      |> stream(:messages, [])
      |> assign(:form, to_form(form))
 
    {:ok, socket} 
  end

  def handle_event("save", %{"chat_message" => params}, socket) do
    %{current_user: current_user} = socket.assigns
    message = ChatMessage.create_message(params["text"], current_user.name, current_user.id)

    IO.inspect(message)
    
    socket = stream_insert(socket, :messages, message)

    IO.inspect(socket)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div id={@id}>
        ChatBox 
        <div>
          <.form
            for={@form}
            phx-submit="save" 
            phx-target={@myself}
          >
          <.input phx-debounce="blur" field={@form[:text]} required />
          <.button>
            Chat
          </.button>
          </.form>
          <div id="messages" phx-update="stream">
            <div
              :for={{text, owner_name} <- @streams.messages}
            >
              <%= owner_name.text %>
            </div>
          </div>
        </div>
      </div>
    """
  end
end
