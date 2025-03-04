defmodule DailyTalk.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias DailyTalk.Accounts.User
  alias DailyTalk.Chat.Room

  schema "messages" do
    field :content, :string
    belongs_to :sender, User
    belongs_to :room, Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :room_id])
    |> validate_required([:content, :sender_id, :room_id])
  end
end
