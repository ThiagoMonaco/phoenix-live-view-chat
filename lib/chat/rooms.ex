defmodule Chat.Rooms do
  alias Chat.Repo
  alias Chat.Rooms.Room

  import Ecto.Query

  @topic_rooms "rooms:lobby"

  def subscribe do
    Phoenix.PubSub.subscribe(Chat.PubSub, @topic_rooms) 
  end

  defp generate_slug do
    charset = Enum.concat([?a..?z, ?A..?Z, ?0..?9])
  
    1..11
    |> Enum.map(fn _ -> Enum.random(charset) end)
    |> List.insert_at(3, ?-)
    |> List.insert_at(7, ?-)
    |> to_string()
  end

  def create_room(name, owner_id) do
    room = %{
        name: name,
        owner_id: owner_id,
        slug: generate_slug() 
      }

    {:ok, new_room} = 
    %Room{}
    |> Room.changeset(room)
    |> Repo.insert()

    Phoenix.PubSub.broadcast(Chat.PubSub, @topic_rooms, {:room_created, new_room})
  end

  def list_rooms() do
    from(r in Room)
    |> Repo.all()
  end
end
