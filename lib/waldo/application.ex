defmodule Waldo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WaldoWeb.Telemetry,
      Waldo.Repo,
      {DNSCluster, query: Application.get_env(:waldo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Waldo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Waldo.Finch},
      # Start a worker by calling: Waldo.Worker.start_link(arg)
      # {Waldo.Worker, arg},
      # Start to serve requests, typically the last entry
      WaldoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Waldo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WaldoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
