defmodule ExampleJsonParse do
  @moduledoc """
  Parses JSON and validates data to conform to model types.
  """

  alias Core.Product
  alias Core.Product.Image
  alias JsonReply.ProductCatalog

  def parse_valid_file do
    parse("product-catalog.json")
  end

  def parse_invalid_file do
    parse("product-catalog-invalid.json")
  end

  # ====== Helpers ===========

  defp parse(file_path) do
    binary = File.read!(file_path)

    with {:ok, map} <- Jason.decode(binary),
         {:ok, catalog} <- Nestru.from_map(map, ProductCatalog, locale: "en-US"),
         {:ok, catalog} <- ProductCatalog.ensure_type_ok(catalog),
         catalog = to_products_list(catalog) do
      {:ok, catalog}
    end
  end

  defp to_products_list(%ProductCatalog{} = catalog) do
    image_by_id =
      catalog.image_assets
      |> Enum.group_by(& &1.id)
      |> Enum.map(fn {key, list} -> {key, list |> List.first() |> Map.drop([:id])} end)
      |> Enum.into(%{})

    Enum.map(catalog.product_entries, fn entry ->
      image = image_by_id[entry.image_asset_id]

      fields =
        entry
        |> Map.from_struct()
        |> Map.drop([:image_asset_id])
        |> Map.put(:image, struct!(Image, Map.from_struct(image)))

      Product.new!(fields)
    end)
  end
end
