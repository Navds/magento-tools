#!/bin/bash

# @author Navds <https://github.com/Navds/magento-tools>

# Magento indexer.php --all is not advised as it could cause memory issue 
# and mysql important load and eventually lead to deadlocks, therefore it 
# is recommended to do it one by one.
# This script is an attempt to simplify this process

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
INDEXER="$BASEDIR/shell/indexer.php"
NARGS=$#

magento_indexes=(
    "catalog_product_attribute"
    "catalog_product_price"
    "catalog_url"
    "catalog_category_product"
    "catalogsearch_fulltext"
    "cataloginventory_stock"
    "tag_summary"
)

function usage()
{
    echo "This script is just standing on top of magento indexer.php"
    echo ""
    echo "./reindexer.sh"
    echo -e "\t-h --help\t To show this help"
    echo -e "\t--only 1,2,3\t Only index 1, 2, 3"
    echo -e "\t--all \t\t Reindex all, --only argument is ignored"
    echo ""
    echo -e "Available index:"
    echo -e "\t[0] catalog_product_attribute     Product Attributes"
    echo -e "\t[1] catalog_product_price         Product Prices"
    echo -e "\t[2] catalog_url                   Catalog URL Rewrites"
    echo -e "\t[3] catalog_category_product      Category Products"
    echo -e "\t[4] catalogsearch_fulltext        Catalog Search Index"
    echo -e "\t[5] cataloginventory_stock        Stock Status"
    echo -e "\t[6] tag_summary                   Tag Aggregation Data"
    echo ""
    echo "Example:"
    echo -e "\t./reindexer.sh --only 0,1\t Reindex product attributes then prices"
    echo -e "\t./reindexer.sh --all\t\t Reindex all those 7"

    exit 1
}


PARAMOK=true
INDEX_LIST=""

# Get command line parameters
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -h|--help)
            usage
            shift ;;
        --only)
            INDEX_LIST=$2
            shift 2 ;;
        --all)
            INDEX_LIST="0,1,2,3,4,5,6"
            break ;;
        *) # unknown option
            POSITIONAL+=("$1")
            PARAMOK=false
            shift
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


# Print help if no command line parameters
if [ $NARGS -lt 1 ] || [ $PARAMOK = false ] ; then
   usage
fi

indexes=($(echo "$INDEX_LIST" | tr ',' '\n'))
for index in ${indexes[@]}; do
    if [ $index -lt 7 ] ; then
        indexer="${magento_indexes[$index]}"
        echo "Reindexing $indexer..."
        php -d memory_limit=-1 $INDEXER --reindex $indexer
        sleep 1
    fi
done

