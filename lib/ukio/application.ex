defmodule Ukio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      UkioWeb.Telemetry,
      # Start the Ecto repository
      Ukio.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ukio.PubSub},
      # Start Finch
      # Not really needed for our application at the moment, we are not doing any http calls.
      # {Finch, name: Ukio.Finch},
      # Start the Endpoint (http/https)
      UkioWeb.Endpoint
      # Start a worker by calling: Ukio.Worker.start_link(arg)
      # {Ukio.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ukio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UkioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
