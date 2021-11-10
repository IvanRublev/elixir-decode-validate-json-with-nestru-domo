defmodule JsonReply.ProductCatalog.ImageAsset do
  @moduledoc false

  use Domo

  @derive Nestru.Decoder

  defstruct id: "",
            uri: %URI{host: "", path: ""},
            byte_size: 0,
            dimensions: {0, 0}

  @type t :: %__MODULE__{
          id: id(),
          uri: uri(),
          byte_size: non_neg_integer(),
          dimensions: {non_neg_integer(), non_neg_integer()}
        }

  @type id :: String.t()

  @type uri :: Core.Product.Image.uri()

  defimpl Nestru.PreDecoder do
    def gather_fields_map(_value, context, map) do
      with {:ok, id} <- JSONPath.get(map, "$.sys.id"),
           {:ok, uri} <- JSONPath.get(map, "$.fields.file['#{context[:locale]}'].url"),
           {:ok, width} <- JSONPath.get(map, "$.fields.file['#{context[:locale]}'].details.image.width"),
           {:ok, height} <- JSONPath.get(map, "$.fields.file['#{context[:locale]}'].details.image.height"),
           {:ok, byte_size} <- JSONPath.get(map, "$.fields.file['#{context[:locale]}'].details.size") do
        {:ok,
         %{
           id: id,
           uri: URI.parse(uri),
           byte_size: byte_size || 0,
           dimensions: {width || 0, height || 0}
         }}
      end
    end
  end
end
