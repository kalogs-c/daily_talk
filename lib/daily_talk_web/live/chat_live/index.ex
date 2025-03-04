defmodule DailyTalkWeb.ChatLive.Index do
  use DailyTalkWeb, :live_view
  alias DailyTalk.Chat
  alias DailyTalkWeb.Endpoint
  alias DailyTalkWeb.ChatLive.Components.MessageForm

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:rooms, Chat.list_rooms())
      |> assign(:scrolled_to_top, false)
      |> assign(:message, %Chat.Message{})

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:room, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    if connected?(socket), do: Endpoint.subscribe("room:#{id}")

    socket
    |> assign(:room, Chat.get_room!(id))
    |> assign_active_room_messages()
  end

  defp assign_active_room_messages(socket) do
    messages = Chat.last_messages_for_room(socket.assigns.room.id)
    oldest_message = List.first(messages)

    socket
    |> stream(:messages, messages)
    |> assign(:oldest_message_id, oldest_message && oldest_message.id)
  end
end
