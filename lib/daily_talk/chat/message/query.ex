defmodule DailyTalk.Chat.Message.Query do
  import Ecto.Query
  alias DailyTalk.Chat.Message

  defp base, do: Message

  def for_room(query \\ base(), room_id, limit) do
    query
    |> where([m], m.room_id == ^room_id)
    |> order_by([m], desc: m.inserted_at)
    |> limit(^limit)
    |> subquery
    |> order_by([m], asc: m.inserted_at)
  end

  def previous_n(query \\ base(), message_id, n) do
    query
    |> where([m], m.id < ^message_id)
    |> order_by([m], {:desc, m.inserted_at})
    |> limit(^n)
    |> order_by([m], {:asc, m.inserted_at})
  end
end
