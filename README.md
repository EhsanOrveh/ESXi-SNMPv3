# ESXi-SNMPv3
Setting up SNMPv3 On ESXi
using Powercli Instead of using SSH.
## Prerequisites:
1. PowerCli. [Link](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.esxi.install.doc/GUID-F02D0C2D-B226-4908-9E5C-2E783D41FE2D.html)
2. ESXi version>=3.5
3. vCenter Server with some ESXis
4. User with administrator privilage on vCenter Server
## Important Notes
1. This script will be set SNMP Configuration on all ESXi host.
2. Make sure Esxi firewall is enabled to receive SNMP on Port 161/UDP.
3. This script enable Only authentication mod in SNMPv3. For more info please read this [link](https://docs.vmware.com/en/VMware-vSphere/7.0/com.vmware.vsphere.monitoring.doc/GUID-8EF36D7D-59B6-4C74-B1AA-4A9D18AB6250.html)
## Testing SNMPv3
You can test SNMPv3 with snmpwalk through this command:
```
time snmpwalk -r 1 -t 5 -v 3 -l authNoPriv -u <Username> -a SHA1 -A <password> <esxi ip or fqdn>
```
