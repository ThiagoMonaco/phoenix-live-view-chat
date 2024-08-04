defmodule Chat.ChatMessage do
  alias Ecto.UUID
  alias Chat.ChatMessage
  defstruct id: nil,
            owner_id: nil,
            owner_name: nil,
            text: ""

  def changeset(chat_message, attrs) do
    types = %{
      id: :string,
      owner_id: :string,
      owner_name: :string,
      text: :string
    }

    {chat_message, types}
    |> Ecto.Changeset.cast(attrs, Map.keys(types))
  end

  def create_message(text, owner_name, owner_id) do
    %ChatMessage{
      text: text,
      owner_name: owner_name,
      owner_id: owner_id,
      id: UUID.generate()
    }
  end
end
