defmodule DailyTalk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DailyTalkWeb.Telemetry,
      DailyTalk.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:daily_talk, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:daily_talk, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DailyTalk.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: DailyTalk.Finch},
      # Start a worker by calling: DailyTalk.Worker.start_link(arg)
      # {DailyTalk.Worker, arg},
      # Start to serve requests, typically the last entry
      DailyTalkWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyTalk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DailyTalkWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
