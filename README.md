<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.89.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_auth_enabled"></a> [active\_directory\_auth\_enabled](#input\_active\_directory\_auth\_enabled) | Set to true to enable Active Directory Authentication | `bool` | `false` | no |
| <a name="input_ad_admin_objects_id"></a> [ad\_admin\_objects\_id](#input\_ad\_admin\_objects\_id) | azurerm postgresql flexible server active directory administrator's object id | `string` | `null` | no |
| <a name="input_addon_resource_group_name"></a> [addon\_resource\_group\_name](#input\_addon\_resource\_group\_name) | The name of the addon vnet resource group | `string` | `""` | no |
| <a name="input_addon_vent_link"></a> [addon\_vent\_link](#input\_addon\_vent\_link) | The name of the addon vnet | `bool` | `false` | no |
| <a name="input_addon_virtual_network_id"></a> [addon\_virtual\_network\_id](#input\_addon\_virtual\_network\_id) | The name of the addon vnet link vnet id | `string` | `""` | no |
| <a name="input_admin_objects_ids"></a> [admin\_objects\_ids](#input\_admin\_objects\_ids) | IDs of the objects that can do all operations on all keys, secrets and certificates. | `list(string)` | `[]` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | The password associated with the admin\_username user | `string` | `null` | no |
| <a name="input_admin_password_length"></a> [admin\_password\_length](#input\_admin\_password\_length) | Length of random password generated. | `number` | `16` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The administrator login name for the new SQL Server | `string` | `null` | no |
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | Map of authorized cidrs to connect database | `map(string)` | `{}` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | The backup retention days for the PostgreSQL Flexible Server. Possible values are between 1 and 35 days. Defaults to 7 | `number` | `7` | no |
| <a name="input_charset"></a> [charset](#input\_charset) | Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created. | `string` | `"utf8"` | no |
| <a name="input_cmk_encryption_enabled"></a> [cmk\_encryption\_enabled](#input\_cmk\_encryption\_enabled) | Enanle or Disable Database encryption with Customer Manage Key | `bool` | `false` | no |
| <a name="input_collation"></a> [collation](#input\_collation) | Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Changing this forces a new resource to be created. | `string` | `"en_US.utf8"` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The creation mode. Can be used to restore or replicate existing servers. Possible values are `Default`, `Replica`, `GeoRestore`, and `PointInTimeRestore`. Defaults to `Default` | `string` | `"Default"` | no |
| <a name="input_database_names"></a> [database\_names](#input\_database\_names) | Specifies the name of the MySQL Database, which needs to be a valid MySQL identifier. Changing this forces a new resource to be created. | `list(string)` | <pre>[<br/>  "maindb"<br/>]</pre> | no |
| <a name="input_delegated_subnet_id"></a> [delegated\_subnet\_id](#input\_delegated\_subnet\_id) | The resource ID of the subnet | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_existing_private_dns_zone"></a> [existing\_private\_dns\_zone](#input\_existing\_private\_dns\_zone) | Name of the existing private DNS zone | `bool` | `false` | no |
| <a name="input_existing_private_dns_zone_id"></a> [existing\_private\_dns\_zone\_id](#input\_existing\_private\_dns\_zone\_id) | n/a | `string` | `null` | no |
| <a name="input_existing_private_dns_zone_name"></a> [existing\_private\_dns\_zone\_name](#input\_existing\_private\_dns\_zone\_name) | The name of the Private DNS zone (without a terminating dot). Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_expiration_date"></a> [expiration\_date](#input\_expiration\_date) | Expiration UTC datetime (Y-m-d'T'H:M:S'Z') | `string` | `"2034-05-22T18:29:59Z"` | no |
| <a name="input_geo_backup_key_vault_key_id"></a> [geo\_backup\_key\_vault\_key\_id](#input\_geo\_backup\_key\_vault\_key\_id) | Key-vault key id to encrypt the geo redundant backup | `string` | `null` | no |
| <a name="input_geo_backup_user_assigned_identity_id"></a> [geo\_backup\_user\_assigned\_identity\_id](#input\_geo\_backup\_user\_assigned\_identity\_id) | User assigned identity id to encrypt the geo redundant backup | `string` | `null` | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Should geo redundant backup enabled? Defaults to false. Changing this forces a new PostgreSQL Flexible Server to be created. | `bool` | `false` | no |
| <a name="input_high_availability"></a> [high\_availability](#input\_high\_availability) | Map of high availability configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-high-availability. `null` to disable high availability | <pre>object({<br/>    standby_availability_zone = optional(number)<br/>  })</pre> | <pre>{<br/>  "standby_availability_zone": 2<br/>}</pre> | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | Specifies the URL to a Key Vault Key (either from a Key Vault Key, or the Key URL for the Key Vault Secret | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure Region where the PostgreSQL Flexible Server should exist. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `""` | no |
| <a name="input_main_rg_name"></a> [main\_rg\_name](#input\_main\_rg\_name) | n/a | `string` | `""` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Map of maintenance window configuration: https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-maintenance | `map(number)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_point_in_time_restore_time_in_utc"></a> [point\_in\_time\_restore\_time\_in\_utc](#input\_point\_in\_time\_restore\_time\_in\_utc) | The point in time to restore from creation\_source\_server\_id when create\_mode is PointInTimeRestore. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | The version of the PostgreSQL Flexible Server to use. Possible values are 5.7, and 8.0.21. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `"5.7"` | no |
| <a name="input_principal_name"></a> [principal\_name](#input\_principal\_name) | The name of Azure Active Directory principal. | `string` | `null` | no |
| <a name="input_principal_type"></a> [principal\_type](#input\_principal\_type) | Set the principal type, defaults to ServicePrincipal. The type of Azure Active Directory principal. Possible values are Group, ServicePrincipal and User. Changing this forces a new resource to be created. | `string` | `"Group"` | no |
| <a name="input_private_dns"></a> [private\_dns](#input\_private\_dns) | n/a | `bool` | `false` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access for the PostgreSQL Flexible Server | `bool` | `false` | no |
| <a name="input_registration_enabled"></a> [registration\_enabled](#input\_registration\_enabled) | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | A container that holds related resources for an Azure solution | `string` | `""` | no |
| <a name="input_rotation_policy"></a> [rotation\_policy](#input\_rotation\_policy) | The rotation policy for azure key vault key | <pre>map(object({<br/>    time_before_expiry   = string<br/>    expire_after         = string<br/>    notify_before_expiry = string<br/>  }))</pre> | `null` | no |
| <a name="input_server_configurations"></a> [server\_configurations](#input\_server\_configurations) | PostgreSQL server configurations to add. | `map(string)` | `{}` | no |
| <a name="input_server_custom_name"></a> [server\_custom\_name](#input\_server\_custom\_name) | User defined name for the PostgreSQL flexible server | `string` | `null` | no |
| <a name="input_size"></a> [size](#input\_size) | Size for PostgreSQL Flexible server sku : https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage. | `string` | `"D2ds_v4"` | no |
| <a name="input_source_server_id"></a> [source\_server\_id](#input\_source\_server\_id) | The resource ID of the source PostgreSQL Flexible Server to be restored. Required when create\_mode is PointInTimeRestore, GeoRestore, and Replica. Changing this forces a new PostgreSQL Flexible Server to be created. | `string` | `null` | no |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | The max storage allowed for the PostgreSQL Flexible Server. Possible values are 32768, 65536, 131072, 262144, 524288, 1048576, 2097152, 4194304, 8388608, and 16777216. | `string` | `"32768"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(string)` | `{}` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | Tier for PostgreSQL Flexible server sku : https://docs.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-compute-storage. Possible values are: GeneralPurpose, Burstable, MemoryOptimized. | `string` | `"GeneralPurpose"` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The name of the virtual network | `string` | `""` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | Specifies the Availability Zone in which this PostgreSQL Flexible Server should be located. Possible values are 1, 2 and 3. | `number` | `1` | no |
## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_key.kvkey](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_postgresql_flexible_server.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server) | resource |
| [azurerm_postgresql_flexible_server_active_directory_administrator.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_active_directory_administrator) | resource |
| [azurerm_postgresql_flexible_server_configuration.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_configuration) | resource |
| [azurerm_postgresql_flexible_server_database.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_postgresql_flexible_server_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_firewall_rule) | resource |
| [azurerm_private_dns_zone.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.addon_vent_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.main2](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_role_assignment.identity_assigned](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_keyvault_crypto_officer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_password.main](https://registry.terraform.io/providers/hashicorp/random/3.7.2/docs/resources/password) | resource |
| [azuread_group.main](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_private_dns_zone_id"></a> [azurerm\_private\_dns\_zone\_id](#output\_azurerm\_private\_dns\_zone\_id) | The Private DNS Zone ID. |
| <a name="output_azurerm_private_dns_zone_virtual_network_link_id"></a> [azurerm\_private\_dns\_zone\_virtual\_network\_link\_id](#output\_azurerm\_private\_dns\_zone\_virtual\_network\_link\_id) | The ID of the Private DNS Zone Virtual Network Link. |
| <a name="output_existing_private_dns_zone_virtual_network_link_id"></a> [existing\_private\_dns\_zone\_virtual\_network\_link\_id](#output\_existing\_private\_dns\_zone\_virtual\_network\_link\_id) | The ID of the Private DNS Zone Virtual Network Link. |
| <a name="output_postgresql_flexible_server_id"></a> [postgresql\_flexible\_server\_id](#output\_postgresql\_flexible\_server\_id) | The ID of the PostgreSQL Flexible Server. |
# 🚀 Built by opsZero!

<a href="https://opszero.com"><img src="https://opszero.com/img/common/opsZero-Logo-Large.webp" width="300px"/></a>

[opsZero](https://opszero.com) provides software and consulting for Cloud + AI. With our decade plus of experience scaling some of the world’s most innovative companies we have developed deep expertise in Kubernetes, DevOps, FinOps, and Compliance.

Our software and consulting solutions enable organizations to:

- migrate workloads to the Cloud
- setup compliance frameworks including SOC2, HIPAA, PCI-DSS, ITAR, FedRamp, CMMC, and more.
- FinOps solutions to reduce the cost of running Cloud workloads
- Kubernetes optimized for web scale and AI workloads
- finding underutilized Cloud resources
- setting up custom AI training and delivery
- building data integrations and scrapers
- modernizing onto modern ARM based processors

We do this with a high-touch support model where you:

- Get access to us on Slack, Microsoft Teams or Email
- Get 24/7 coverage of your infrastructure
- Get an accelerated migration to Kubernetes

Please [schedule a call](https://calendly.com/opszero-llc/discovery) if you need support.

<br/><br/>

<div style="display: block">
  <img src="https://opszero.com/img/common/aws-advanced.png" alt="AWS Advanced Tier" width="150px" >
  <img src="https://opszero.com/img/common/aws-devops-competency.png" alt="AWS DevOps Competency" width="150px" >
  <img src="https://opszero.com/img/common/aws-eks.png" alt="AWS EKS Delivery" width="150px" >
  <img src="https://opszero.com/img/common/aws-public-sector.png" alt="AWS Public Sector" width="150px" >
</div>
<!-- END_TF_DOCS -->