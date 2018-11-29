# magento-tools
helper scripts for your magento development

### Reindexer

```
./reindexer.sh
        -h --help        To show this help
        --only 1,2,3     Only index 1, 2, 3
        --all            Reindex all, --only argument is ignored

Available index:
        [0] catalog_product_attribute     Product Attributes
        [1] catalog_product_price         Product Prices
        [2] catalog_url                   Catalog URL Rewrites
        [3] catalog_category_product      Category Products
        [4] catalogsearch_fulltext        Catalog Search Index
        [5] cataloginventory_stock        Stock Status
        [6] tag_summary                   Tag Aggregation Data

Example:
        ./reindexer.sh --only 0,1        Reindex product attributes then prices
        ./reindexer.sh --all             Reindex all those 7
```
