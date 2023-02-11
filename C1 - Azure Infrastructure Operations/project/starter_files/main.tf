provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "linux-rg" {
  name     = var.resource_group_name
  location = var.location
  tags = var.tags
}

resource "azurerm_virtual_network" "linux-vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name
  tags = var.tags
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.linux-rg.name
  virtual_network_name = azurerm_virtual_network.linux-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "linux-nsg" {
  name = "${var.prefix}-SecurityGroup"
  location = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name

  security_rule = [ 
  {
    name = "AllowVnetInbound"
    priority = 65000
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name = "AllowAzureLoadBalancerInbound"
    priority = 65001
    direction = "Inbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "AzureLoadBalancer"
    destination_address_prefix = "*"
  },
  {
    name = "DenyAllInbound"
    priority = 65500
    direction = "Inbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  },
  {
    name = "AllowVnetOutbound"
    priority = 65000
    direction = "Outbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name = "AllowInternetOutbound"
    priority = 65001
    direction = "Outbound"
    access = "Allow"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "Internet"
  },
  {
    name = "DenyAllOutbound"
    priority = 65500
    direction = "Outbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
  ]

  tags = var.tags
}

resource "azurerm_network_interface" "linux-nic" {
  count = var.counter
  name                = "${var.prefix}-nic${count.index}"
  resource_group_name = azurerm_resource_group.linux-rg.name
  location            = azurerm_resource_group.linux-rg.location
  tags = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "linux-public-ip" {
  name = "${var.prefix}-public-ip"
  location = var.location
  resource_group_name = azurerm_resource_group.linux-rg.name
  allocation_method = "Static"
  tags = var.tags
}

resource "azurerm_lb" "linux-lb" {
  name = "${var.prefix}-lb"
  location = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name
  frontend_ip_configuration {
    name = "${var.prefix}-PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.linux-public-ip.id
  }
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "linux-backend-address-pool" {
  name = "${var.prefix}-BackEndAddressPool"
  loadbalancer_id = azurerm_lb.linux-lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "linux-nic-bap-association" {
  count = var.counter
  network_interface_id = element(azurerm_network_interface.linux-nic.*.id, count.index)
  ip_configuration_name = "${var.prefix}-configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.linux-backend-address-pool.id
}

resource "azurerm_availability_set" "linux-vm-aset" {
  name = "${var.prefix}-aset"
  location = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  count                           = var.counter
  name                            = "${var.prefix}-vm${count.index}"
  resource_group_name             = azurerm_resource_group.linux-rg.name
  location                        = azurerm_resource_group.linux-rg.location
  size                            = var.vmsize

  availability_set_id = azurerm_availability_set.linux-vm-aset.id

  admin_username = "${var.username}"
  admin_password = "${var.password}"
  disable_password_authentication = false


  network_interface_ids = [
    azurerm_network_interface.linux-nic[count.index].id,
  ]

  source_image_id = "/subscriptions/d9bd30f5-56fc-4a47-8929-d6f11cfbe702/resourceGroups/Ubuntu-RG/providers/Microsoft.Compute/images/ubuntuImage"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = var.tags
}

/*võimalik, et on mitu managed diski vaja*/
resource "azurerm_managed_disk" "linux-managed-disk" {
  count = var.counter
  name = "${var.prefix}-md${count.index}"
  location = azurerm_resource_group.linux-rg.location
  resource_group_name = azurerm_resource_group.linux-rg.name
  storage_account_type = "Standard_LRS"
}