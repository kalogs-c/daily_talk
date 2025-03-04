defmodule DailyTalk.Repo do
  use Ecto.Repo,
    otp_app: :daily_talk,
    adapter: Ecto.Adapters.SQLite3
end
