defmodule OrbitTp.System do
  use Agent

  alias OrbitTp.{Body, Gravity}

  def init(body1, body2) do
    Agent.start_link(fn -> {body1, body2} end, name: __MODULE__)
  end

  def get_state(time) do
  end

  defp apply_components(components, time) do
    Enum.each(components, &apply_component(&1, time))
  end

  defp apply_component(Gravity, time) do
    {body1, body2} = Agent.get(__MODULE__, & &1)
  end

  defp get_distance(body1, body2) do

  end
end
