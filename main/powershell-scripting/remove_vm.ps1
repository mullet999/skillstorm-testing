
# To stop the VM and not require input by adding force
Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -force

# To remove the VM and not require input by adding force
Remove-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -force

# show all resources that are left in the resource group
Get-AzResource -ResourceGroupName $vm.ResourceGroupName | 
    Select-Object -Property Name, ResourceType, ResourceGroupName

# delete the network interface
Get-AzNetworkInterface -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name |
    Remove-AzNetworkInterface -force

#delete the network security group
Get-AzNetworkSecurityGroup -ResourceGroupName $vm.ResourceGroupName |
    Remove-AzNetworkSecurityGroup -force

#delete the public ip
Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName |
    Remove-AzPublicIpAddress -force

#delete the virtual network
Get-AzVirtualNetwork -ResourceGroupName $vm.ResourceGroupName |
    Remove-AzVirtualNetwork -force

#delete the managed disk
Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $vm.StorageProfile.OSDisk.Name |
    Remove-AzDisk -force

# show all resources that are left in the resource group
Get-AzResource -ResourceGroupName $vm.ResourceGroupName | 
    Select-Object -Property Name, ResourceType, ResourceGroupName
