defmodule OrbitTp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Supervisor.child_spec(OrbitTp.Body, start: {OrbitTp.Body, :init, [:adi, %{mass: 5, x: 0, y: 10}]})
      Supervisor.child_spec(OrbitTp.Body, start: {OrbitTp.Body, :init, [:josh, %{mass: 10, x: 0, y: 5}]})
    ]

    opts = [strategy: :one_for_one, name: OrbitTp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
