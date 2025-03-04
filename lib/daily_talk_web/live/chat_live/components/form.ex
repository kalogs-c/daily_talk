defmodule DailyTalkWeb.ChatLive.Components.MessageForm do
  use DailyTalkWeb, :live_component
  import DailyTalkWeb.CoreComponents
  alias DailyTalk.Chat
  alias DailyTalk.Chat.Message

  @impl true
  def update(assigns, socket) do
    message_changeset = Chat.change_message(%Message{})

    socket =
      socket
      |> assign(assigns)
      |> assign_form(message_changeset)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-submit="save" phx-change="update" phx-target={@myself}>
        <.input
          autocomplete="off"
          phx-keydown={show_modal("edit_message")}
          phx-key="ArrowUp"
          field={@form[:content]}
          type="text"
        />
        <:actions>
          <.button>send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("update", %{"message" => message}, socket) do
    changeset = Chat.change_message(%Message{}, message)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  @impl true
  def handle_event("save", %{"message" => %{"content" => content}}, socket) do
    Chat.create_message(%{
      content: content,
      sender_id: socket.assigns.sender_id,
      room_id: socket.assigns.room_id
    })

    changeset = Chat.change_message(%Message{})
    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "message")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
