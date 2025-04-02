# Mon titre
## Mon sous titre
### Mon dernier sous titre

``` powershell
    Invoke-Command -Session $session -ScriptBlock {
        # Modifier l'IP de l'interface Ethernet
        New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.1.100" -PrefixLength 24 -DefaultGateway "192.168.1.1"
    
        # Modifier les DNS
        Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8", "8.8.4.4")
    }

```

1. etape 01
2. etape 02

- caracteristique 01
- caracteristique 02

