
#create vm and assign to a variable and ask for credentials # I used user as darick999
$azVmParams = @{
    ResourceGroupName   = 'learn-6f00a9ac-c29c-41e7-9bad-06287b6f2d07'
    Name                = 'testvm-eus-01'
    Credential          = (Get-Credential)
    Location            = 'eastus'
    Image               = 'Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest'
    OpenPorts           = 22
    PublicIpAddressName = 'testvm-eus-01'
}
New-AzVm @azVmParams

#get vm and assign to a variable
$vm = Get-AzVM -Name testvm-eus-01 -ResourceGroupName learn-6f00a9ac-c29c-41e7-9bad-06287b6f2d07

#shows vm information
$vm

#show hardware profile and vm size
$vm.HardwareProfile

#show os disk
$vm.StorageProfile.OsDisk

#show vm size
$vm | Get-AzVMSize

#get public ip and assign to a variable
$ip = Get-AzPublicIpAddress -ResourceGroupName learn-6f00a9ac-c29c-41e7-9bad-06287b6f2d07 -Name testvm-eus-01

#ssh into vm
ssh darick999@$($ip.IpAddress)
# To sign out type exit
