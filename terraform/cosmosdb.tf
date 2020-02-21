data "azurerm_cosmosdb_account" "db_account" {
    name                = "${var.prefix}-db-account"
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_cosmosdb_mongo_database" "db" {
    name                = "${var.prefix}-db"
    resource_group_name = azurerm_resource_group.rg.name
    account_name        = data.azurerm_cosmosdb_account.db_account.name
    throughput          = 400
}

resource "azurerm_cosmosdb_mongo_collection" "db_collection" {
    name                = "${var.prefix}-db-collection"
    resource_group_name = azurerm_resource_group.rg.name
    account_name        = data.azurerm_cosmosdb_account.db_account.name
    database_name       = azurerm_cosmosdb_mongo_database.db.name
    
    default_ttl_seconds = "777"
    shard_key           = "uniqueKey"
    throughput          = 400
}
