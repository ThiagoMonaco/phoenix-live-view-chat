defmodule ChatWeb.ChatBoxLive do
  alias Chat.Rooms
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
    
    changeset = ChatMessage.changeset(%ChatMessage{}, %{})

    socket = assign(socket, :form, to_form(changeset))

    send(self(), {:created_message, message})

    {:noreply, socket}
  end
  
  def handle_event("validate", %{"chat_message" => params}, socket) do
    changeset =
      %ChatMessage{}
      |> ChatMessage.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end
  def update(assigns, socket) do
    socket = if Map.has_key?(assigns, :new_message) do
      stream_insert(socket, :messages, assigns.new_message)
    else
      socket
    end

    socket = 
      socket
      |> assign(assigns)
    {:ok, socket}
  end




  def render(assigns) do
    ~H"""
      <div id={@id}>
        ChatBox 
        <div>
          <.form
            for={@form}
            phx-submit="save" 
            phx-change="validate"
            phx-target={@myself}
          >
          <.input phx-debounce="blur" field={@form[:text]} required />
          <.button>
            Chat
          </.button>
          </.form>
          <div id="messages" phx-update="stream">
            <div
              :for={{_text, owner_name} <- @streams.messages}
            >
              <%= owner_name.text %>
            </div>
          </div>
        </div>
      </div>
    """
  end
end
