# ExampleJsonParse

This [Elixir](https://elixir-lang.org/) app parses the product catalog [JSON example file](https://github.com/contentful/content-models/tree/master/product-catalogue) 
from Contentful CMS.

The [Nestru](https://github.com/IvanRublev/Nestru) library is applied to 
parse a JSON file to `JsonReply.ProductCatalog` nested struct.
Then the app assembles the core model as a list of `Core.Product` structs
from the catalog.

The [Domo](https://github.com/IvanRublev/Domo) library is applied to validate
the core model structs to conform to their type `t()` definitions and associated
preconditions.

## In detail

The Domo generated callbacks `ensure_type_ok/1` and `new!/1` are used 
to validate structs conforming to their types and preconditions. 
The `Core.Product.Image.uri()` type from core model referenced in 
`JsonReply.ProductCatalog.ImageAsset.t()` lifts the type and precondition 
checks to the product catalog. 

That is the call to `ProductCatalog.ensure_type_ok/1` validates uri fields
of image assets with precondition function for core type `uri()` 
that requires `URI` value to have both `host` and `path` fields specified.

## Give it a try 

With `iex -S mix`:

Run `ExampleJsonParse.parse_valid_file()` to see parsed and valid core model 
structs built from JSON.

Run `ExampleJsonParse.parse_invalid_file()` to see the index where 
the malformed object is located in `product-catalog-invalid.json`.
