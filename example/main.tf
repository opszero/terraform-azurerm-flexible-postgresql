provider "azurerm" {
  features {}
}


module "flexible-postgresql" {
  source              = "./../."
  name                = "postgresql"
  resource_group_name = ""
  location            = ""

  #**************************server configuration***************************
  postgresql_version = "16"
  admin_username     = "postgresqlusername"
  admin_password     = "ba5yatgfgfhdsv6A3ns2lu4gqzzc"
  tier               = "Burstable"
  size               = "B1ms"
  database_names     = ["maindb"]
  high_availability = {
    mode                      = "ZoneRedundant"
    standby_availability_zone = 2
  }

  #**************************private server*********************************
  #(Resources to recreate when changing private to public cluster or vise-versa )
  virtual_network_id   = ""
  private_dns          = true
  delegated_subnet_id  = ""
  registration_enabled = true

  public_network_access_enabled = true
  allowed_cidrs = {
    "allowed_all_ip"      = "0.0.0.0/0"
    "allowed_specific_ip" = "157.48.192.208/32"
  }


}
