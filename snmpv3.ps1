$vcenter_server = Read-Host "Enter vCenter Server FQDN or IP"
$snmpuser = Read-Host "Enter SNMPv3 User for authentication" 
$snmppassword = Read-Host "Enter SNMPv3 password for authentication" 
Write-Host "Enter vCenter server Credential: "
$Pcredential = Get-Credential
Write-Host "Connecting to vCenter server ..."`n
Connect-VIServer -Server $vcenter_server -Credential $Pcredential  -ErrorAction Stop


#getting all esxi host in vcenter server
$allesxi = Get-VMHost 

#setting up snmp 
foreach($esxihost in $allesxi)
{
    
    Write-Host "setting up host " $esxihost "..." `n -ForegroundColor Blue

    #connecting to esxi esxcli 
    $esxi = get-vmhost -name $esxihost
    $cli = Get-EsxCli -VMHost $esxi -V2
    
    #stop and start snmp service to create enginid 
    $b = $cli.system.snmp.set.CreateArgs()
    $b['enable'] = "true"
    $cli.system.snmp.set.Invoke($b) | Out-Null
    $b = $cli.system.snmp.set.CreateArgs()
    $b['enable'] = "false"
    $cli.system.snmp.set.Invoke($b)  | Out-Null
    
    
    #setting encryption algorithm
    $b = $cli.system.snmp.set.CreateArgs()
    $b['authentication'] = "SHA1"
    $cli.system.snmp.set.Invoke($b) | Out-Null
    

    #generating authentication hash 
    $a = $cli.system.snmp.hash.CreateArgs()
    $a['authhash'] = $snmppassword
    $a['rawsecret'] = 'true'
    $hash = $cli.system.snmp.hash.Invoke($a)
    $h = $hash.authhash
    

    #disabling snmp service 
    $b = $cli.system.snmp.set.CreateArgs()
    $b['enable'] = "false"
    $cli.system.snmp.set.Invoke($b) | Out-Null
    

    #setting up snmp user
    $b = $cli.system.snmp.set.CreateArgs()
    $b['users'] = "$snmpuser/$h/-/auth"
    $cli.system.snmp.set.Invoke($b) | Out-Null
    
    Start-Sleep -Seconds 5
    #start snmp service
    $b = $cli.system.snmp.set.CreateArgs()
    $b['enable'] = "true"
    $cli.system.snmp.set.Invoke($b) | Out-Null
    

    Write-Host "esxi" $esxihost "Done"  -ForegroundColor Green
}
