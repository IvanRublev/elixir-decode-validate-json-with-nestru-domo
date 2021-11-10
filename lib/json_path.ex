defmodule JSONPath do
  @moduledoc false

  def get(map, path) do
    with {:ok, [first | _]} <- ExJSONPath.eval(map, path) do
      {:ok, first}
    end
  end

  def get_list(map, path) do
    ExJSONPath.eval(map, path)
  end
end
