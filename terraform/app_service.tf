resource "azurerm_app_service_plan" "service_plan" {
    name                = "${var.prefix}-servie-plan"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    sku {
        tier = "Free"
        size = "F1"
    }
}

resource "azurerm_app_service" "app_service" {
    name                = "${var.prefix}-servie-plan"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service_plan.service_plan.id

    site_config {
        scm_type = "LocalGit"
    }

    app_settings = {
        https_only = true
        FUNCTIONS_WORKER_RUNTIME = "node"
        WEBSITE_NODE_DEFAULT_VERSION = "~12"
        FUNCTION_APP_EDIT_MODE = "readonly"
        "SOME_KEY" = "some-value"
    }
}
