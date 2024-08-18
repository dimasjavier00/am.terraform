# configuracion de servidor de base datos

# servidor de base de datos
resource "azurerm_mssql_server" "sql_server"{  # "nombreServicioAzure" "nombrequeAsignamos" 

    name = "sqlserver-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    version = "12.0"
    administrator_login = "sqladmin"
    administrator_login_password = var.password

    tags = var.tags

}

# "baseDatostoConfigure" "nombrequeUtilizaremosparareferenciar" 
resource "azurerm_mssql_database" "sql_db" { 

    name = "am.db" #nombre de la base de datos
    server_id = azurerm_mssql_server.sql_server.id #en que servidor guardaremos la base de datos. Azure lo se asigna automaticamente
    sku_name = "S0" #base de datos mas barata del presupuesto.
    tags = var.tags
}

# configurando private enpoint. 
resource "azurerm_private_endpoint" "sql_private_endpoint"{

    name = "sql-private-endpoint-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    subnet_id = azurerm_subnet.subnetdb.id # segemento de subred en donde esta alojado

    #definir las conexiones.
    private_service_connection {  # conecta el servidor de base de datos. 
        name = "sql-private-ec-${var.project}-${var.environment}"
        private_connection_resource_id = azurerm_mssql_server.sql_server.id
        subresource_names = ["sqlServer"] #se especifica el servicio que permite pasar por este cable. en este caso solo sqlserver
        is_manual_connection = false 
    }
    tags = var.tags
}

# configurando servidor dns
resource "azurerm_private_dns_zone" "private_dns_zone"{
    name= "private.dbserver.database.windows.net" #url que utilizaremos para acceder al dns publica(Dominio privado).
    resource_group_name = azurerm_resource_group.rg.name
    tags = var.tags

}

#configurando los records del dns zone.
resource "azurerm_private_dns_a_record" "private_dns_a_record"{

    name = "sqlserver-record-${var.project}-${var.environment}"
    zone_name = azurerm_private_dns_zone.private_dns_zone.name
    resource_group_name = azurerm_resource_group.rg.name
    ttl = 300 # tiempos de pings de conexion 
    
    # ip addres que se quieren registrar en el dns. es un arreglo de ips. 
    records = [azurerm_private_endpoint.sql_private_endpoint.private_service_connection[0].private_ip_address] #extrayendo la ip del private_enpoint

}

# private dns virtual network. conectamos el dns a la red virtual que ya teniamos definida. Similar al private-enpoint pero ya especifico para el dns con el vnet(red vitual).
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link"{
    name = "vnetlink-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name #referenciando el dns a conectar.
    virtual_network_id = azurerm_virtual_network.vnet.id  # la red virtual que conectamos.
}

resource "azurerm_sql_firewall_rule" "allow_my_ip" {
  name                = "allow-my-ip"
  resource_group_name = azurerm_mssql_server.sql_server.resource_group_name
  server_name         = azurerm_mssql_server.sql_server.name
  start_ip_address    = "190.53.248.219"
  end_ip_address      = "190.53.248.219"
}