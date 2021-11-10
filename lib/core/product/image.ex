defmodule Core.Product.Image do
  @moduledoc false

  use Domo

  @valid_uri_placeholder %URI{host: "", path: ""}

  defstruct uri: @valid_uri_placeholder,
            dimensions: {0, 0},
            byte_size: 0

  @type t :: %__MODULE__{
          uri: uri(),
          dimensions: {non_neg_integer(), non_neg_integer()},
          byte_size: non_neg_integer()
        }

  @type uri :: URI.t()
  precond uri: &validate_uri/1

  defp validate_uri(value) do
    if value.host && value.path do
      :ok
    else
      {:error, "URI should have both host and path specified."}
    end
  end
end
