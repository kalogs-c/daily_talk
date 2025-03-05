defmodule DailyTalkWeb.ChatLive.Index do
  use DailyTalkWeb, :live_view
  alias DailyTalk.Chat
  alias DailyTalkWeb.Endpoint
  alias DailyTalkWeb.ChatLive.Components.Messages
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

  defp assign_last_user_message(%{assigns: %{current_user: current_user}} = socket, message)
       when current_user.id == message.sender_id do
    assign(socket, message: message)
  end

  defp assign_last_user_message(socket, _message), do: socket

  @impl true
  def handle_info(%{event: "new_message", payload: %{message: message}}, socket) do
    socket =
      socket
      |> stream_insert(:messages, Chat.preload_message_sender(message), at: -1)
      |> assign_last_user_message(message)

    {:noreply, socket}
  end

  @impl true
  def handle_event("unpin_scrollbar_from_top", _params, socket) do
    {:noreply, assign(socket, scrolled_to_top: false)}
  end

  @impl true
  def handle_event("load_more", _params, socket) do
    messages = Chat.list_previous_messages(socket.assigns.oldest_message_id, 5)
    oldest_message = List.last(messages)

    socket =
      socket
      |> stream_batch_insert(:messages, messages, at: 0)
      |> assign(:oldest_message_id, oldest_message && oldest_message.id)
      |> assign(:scrolled_to_top, true)

    {:noreply, socket}
  end
end
