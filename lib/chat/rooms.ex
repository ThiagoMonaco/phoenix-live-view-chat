defmodule Chat.Rooms do
  alias Chat.Repo
  alias Chat.Rooms.Room

  import Ecto.Query

  @topic_rooms "rooms:lobby"
  @topic_single_rooms "rooms:"

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

  defp get_topic_slug(slug) do
    "#{@topic_single_rooms}:#{slug}"
  end

  def join_room(slug, user_id, name) do
    ChatWeb.Presence.track(self(), get_topic_slug(slug), user_id, %{
      name: name
    })
    Phoenix.PubSub.subscribe(Chat.PubSub, get_topic_slug(slug))
  end

  def list_users_room(slug) do
    ChatWeb.Presence.list(get_topic_slug(slug))
  end

  def send_message(slug, message) do
    Phoenix.PubSub.broadcast(Chat.PubSub, get_topic_slug(slug), {:message_send, message})
  end
end
