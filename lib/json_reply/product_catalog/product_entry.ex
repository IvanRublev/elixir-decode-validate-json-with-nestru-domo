defmodule JsonReply.ProductCatalog.ProductEntry do
  @moduledoc false

  use Domo

  alias JsonReply.ProductCatalog.ImageAsset

  @derive Nestru.Decoder

  defstruct product_name: "",
            slug: "",
            image_asset_id: "",
            price: 0,
            tags: [],
            updated_at: ~N[2000-01-01 23:00:07]

  @type t :: %__MODULE__{
          product_name: String.t(),
          slug: String.t(),
          image_asset_id: ImageAsset.id(),
          price: non_neg_integer(),
          tags: [String.t()],
          updated_at: NaiveDateTime.t()
        }

  defimpl Nestru.PreDecoder do
    def gather_fields_map(_value, context, map) do
      with {:ok, image_asset_id} <- JSONPath.get(map, "$.fields.image['#{context[:locale]}'][0].sys.id"),
           {:ok, price} <- JSONPath.get(map, "$.fields.price['#{context[:locale]}']"),
           {:ok, product_name} <- JSONPath.get(map, "$.fields.productName['#{context[:locale]}']"),
           {:ok, slug} <- JSONPath.get(map, "$.fields.slug['#{context[:locale]}']"),
           {:ok, tags} <- JSONPath.get(map, "$.fields.tags['#{context[:locale]}']"),
           {:ok, updated_at_string} <- JSONPath.get(map, "$.sys.updatedAt"),
           {:ok, updated_at} <- NaiveDateTime.from_iso8601(updated_at_string) do
        {:ok,
         %{
           image_asset_id: image_asset_id,
           price: price,
           product_name: product_name,
           slug: slug,
           tags: tags,
           updated_at: updated_at
         }}
      end
    end
  end
end
