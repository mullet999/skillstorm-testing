
### To test the vmss application:
Ensure vm instances are started - https://portal.azure.com/#@skillstormnextgen.onmicrosoft.com/resource/subscriptions/d1e91307-b327-4fc6-a5ac-0dc833d19cfe/resourceGroups/joshua_davis_rg/providers/Microsoft.Compute/virtualMachineScaleSets/lvmss1/instances

Give them 10 to 20 mins to startup (I chose the lowest sku so they are slow)

Go to the public ip to view the site - http://172.174.83.59/

If it still shows the default page it may still be trying to start.


### To test the SQL connection:
Add your public ip to the web nsg rules

Login to the vm by: ssh adminuser@172.174.83.59

If errors on ssh about it changing run ssh-keygen -R 172.174.83.59 then try again

command: sqlcmd -S jdmssqlserver.database.windows.net -d jdmssqlserver-db1 -U 'adminuser' -P '"Passw0rd@123"' -Q "SELECT * FROM Table1;" -s "|" -W

