defmodule ChatWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :chat,
    pubsub_server: Chat.PubSub

  
  def simple_presence_map(presences) do
    Enum.into(presences, %{}, fn {user_id, %{metas: [meta | _]}} -> 
      {user_id, meta}
    end)
  end

  def map_remove_presences(socket, leaves) do
    user_ids = Enum.map(leaves, fn {user_id, _} -> user_id end)
    Map.drop(socket.assigns.presences, user_ids)
  end


  def map_add_presences(socket, joins) do
    Map.merge(socket.assigns.presences, simple_presence_map(joins)) 
  end
end
