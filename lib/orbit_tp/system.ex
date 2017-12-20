defmodule OrbitTp.System do
  @moduledoc """
  This System assumes that the bodies rotate counter-clockwise in the
  coordinate frame with a constant velocity about the axis going through
  their center of mass.
  """

  use Agent

  alias OrbitTp.{Body, ComponentApplier}

  defstruct ~w(body1 body2 updated_at)a

  @components [Gravity]

  def init(body1, body2, updated_at \\ 0) do
    # TODO: Update body to body names which will point to specific GenServer
    # processes.
    Agent.start_link(fn -> st(body1, body2, updated_at) end, name: __MODULE__)
  end

  def bodies(), do: Agent.get(__MODULE__, & {&1.body1, &1.body2})

  def updated_at(), do: Agent.get(__MODULE__, & &1.updated_at)

  def update_bodies(body1, body2) do
    {b1, b2} = bodies()
    Body.update_pos(b1, {body1.x, body1.y})
    Body.update_pos(b2, {body2.x, body2.y})
  end

  def update_time(time) do
    Agent.update(__MODULE__, &%__MODULE__{&1 | updated_at: time})
  end

  def apply_and_update(time) do
    @components
    |> Enum.map(&Module.concat(ComponentApplier, &1))
    |> apply_components(time)
  end

  def get_body_states() do
    bodies()
    |> Tuple.to_list()
    |> Enum.map(&Body.get_body/1)
  end

  defp st(body1, body2, updated_at) do
    %__MODULE__{body1: body1, body2: body2, updated_at: updated_at}
  end

  defp apply_components(components, time) do
    Enum.each(components, &apply(&1, :run, [__MODULE__, time]))
  end
end
