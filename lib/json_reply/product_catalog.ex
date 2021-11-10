defmodule JsonReply.ProductCatalog do
  @moduledoc false

  use Domo

  alias JsonReply.ProductCatalog.{
    ImageAsset,
    ProductEntry
  }

  defstruct image_assets: [%ImageAsset{}],
            product_entries: [%ProductEntry{}]

  @type t :: %__MODULE__{
          image_assets: [ImageAsset.t()],
          product_entries: [ProductEntry.t()]
        }

  defimpl Nestru.PreDecoder do
    def gather_fields_map(_value, _context, map) do
      with {:ok, product_entries} <- JSONPath.get_list(map, "$.entries[?(@.sys.contentType.sys.id == 'product')]"),
           {:ok, image_assets} <- JSONPath.get_list(map, "$.assets[?(@.sys.type == 'Asset')]") do
        {:ok, %{image_assets: image_assets, product_entries: product_entries}}
      end
    end
  end

  defimpl Nestru.Decoder do
    def from_map_hint(_value, context, _map) do
      {:ok,
       %{
         image_assets: &Nestru.from_list_of_maps(&1, ImageAsset, context),
         product_entries: &Nestru.from_list_of_maps(&1, ProductEntry, context)
       }}
    end
  end
end
