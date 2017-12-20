defmodule OrbitTp.Body do
  use Agent

  defstruct ~w(mass x y)a

  def init(name, args) do
    Agent.start_link(fn -> struct!(__MODULE__, args) end, name: name)
  end

  def update_pos(name, {x, y}) do
    Agent.get_and_update(name, &%__MODULE__{&1 | x: x, y: y})
  end

  def get_pos(name) do
    Agent.get(name, &{&1.x, &1.y})
  end
end
