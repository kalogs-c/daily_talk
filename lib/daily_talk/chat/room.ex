defmodule DailyTalk.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias DailyTalk.Chat.Message

  schema "rooms" do
    field :name, :string
    field :description, :string

    has_many :messages, Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
