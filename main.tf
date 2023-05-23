# Defines an Azure network interface resource
resource "azurerm_network_interface" "my-nic" {

  # Defines the no of network interfaces to be created based on the value of var.vm-count  
  count               = var.vm-count

  # Sets the name of the network interface
  name                = "${var.vm-prefix}-my-nic-${count.index}"
  location            = "eastus2"
  resource_group_name = "cohort3-uyi-rg"

  # Defines the IP configuration for the network interface, 
  #including the name, subnet ID, and IP address allocation type.
  ip_configuration {
    name                          = "nic-ipconfig"
    subnet_id                     = azurerm_subnet.subnet-names[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

# This block retrieves information about an existing resource group
data "azurerm_resource_group" "cohort3-uyi-rg" {
  name = "cohort3-uyi-rg"
}

# This block defines an Azure virtual machine resource.
resource "azurerm_virtual_machine" "my-vms" {
  count               = var.vm-count
  name                = "${var.vm-prefix}-my-vms-${count.index}"
  location            = "eastus2"
  resource_group_name = data.azurerm_resource_group.cohort3-uyi-rg.name

  # References the network interface IDs created earlier to associate the 
  #virtual machine with the corresponding network interface
  network_interface_ids = [
  azurerm_network_interface.my-nic[count.index].id
  ]
  vm_size = var.vm-size
  
  # Defines the image reference for the VM's operating system 
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.vm-image
    version   = "latest"
  }
  
  # Defines the OS disk for the virtual machine
  storage_os_disk {
    name              = "${var.vm-prefix}-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  
  #  sets the computer name, admin username, and password for the VM
  os_profile {
    computer_name  = "${var.vm-prefix}-my-vms-${count.index}"
    admin_username = "adminuser"
    admin_password = "1RRiverniger."
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  # lists the dependencies for this resource, 
  # which are the network interface and subnet resources
  depends_on = [
    azurerm_network_interface.my-nic,
    azurerm_subnet.subnet-names
  ]
}

# Retrieves information about an existing virtual network 
data "azurerm_virtual_network" "dev-vnet" {
  name                = "dev-vnet"
  resource_group_name = data.azurerm_resource_group.cohort3-uyi-rg.name
}

# Defines Azure subnet resource
resource "azurerm_subnet" "subnet-names" {
  count               = var.vm-count
  name                = "${var.subnet-names[count.index]}"
  resource_group_name = data.azurerm_resource_group.cohort3-uyi-rg.name
  virtual_network_name = data.azurerm_virtual_network.dev-vnet.name
  address_prefixes     = ["10.0.${count.index}.0/24"]
}
