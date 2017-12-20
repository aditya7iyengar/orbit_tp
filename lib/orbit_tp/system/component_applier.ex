defmodule OrbitTp.ComponentApplier do
  @moduledoc false

  @callback run(Atom.t, integer()) :: :ok | :error

  defmacro __using__(_opts) do
    quote do
      @behaviour OrbitTp.ComponentApplier

      def run(system, time), do: raise "run/2 is not defined for #{__MODULE__}"

      defoverridable [run: 2]
    end
  end
end
