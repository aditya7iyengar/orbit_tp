defmodule OrbitTp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias OrbitTp.{Body, System}

  def start(_type, _args) do
    children = [
      Supervisor.child_spec(Body, start: {Body, :init, [:adi, %{mass: 5, x: 0, y: 10}]}, id: :adi),
      Supervisor.child_spec(Body, start: {Body, :init, [:josh, %{mass: 10, x: 0, y: 5}]}, id: :josh),
      Supervisor.child_spec(System, start: {System, :init, [:adi, :josh, 0]})
    ]

    opts = [strategy: :one_for_one, name: OrbitTp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
