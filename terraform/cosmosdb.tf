resource "azurerm_cosmosdb_account" "db_account" {
    name                = "${var.prefix}-db-account"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    offer_type          = "Standard"
    kind                = "GlobalDocumentDB"

    enable_automatic_failover = false

    consistency_policy {
        consistency_level       = "BoundedStaleness"
        max_interval_in_seconds = 10
        max_staleness_prefix    = 200
    }

    geo_location {
        prefix            = "${var.prefix}-db-customid"
        location          = azurerm_resource_group.rg.location
        failover_priority = 0
    }
}

resource "azurerm_cosmosdb_sql_database" "db" {
    name                = "${var.prefix}-db-account"
    resource_group_name = azurerm_resource_group.rg.name
    account_name        = azurerm_cosmosdb_account.db_account.name

    throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "container" {
    name                = "${var.prefix}-container"
    resource_group_name = azurerm_resource_group.rg.name
    account_name        = azurerm_cosmosdb_account.db_account.name
    database_name       = azurerm_cosmosdb_sql_database.db.name

    partition_key_path  = "/definition/id"
    throughput          = 400

    unique_key {
        paths = ["/definition/idlong", "/definition/idshort"]
    }
}
