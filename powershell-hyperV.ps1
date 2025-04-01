$variable1 = "ma variable"

Write-Host $variable1


# /!\ INSTALLER POWERSHELL CORE 7.2 /!\
#winget install --id Microsoft.PowerShell -e

# New-VM => nvlle VM 
# Get-VM => obtenir VM
# Set-VM => modifier VM

#New-VM 
#-Name "VMMaster" 
#-MemoryStartupBytes 4GB 
#-ProcessorCount 2
#-BootDevice "C:\Iso\ubuntu-22.04.4-desktop-amd64.iso" 
#-Generation 2
#-Path "C:\VMs"
#
#New-VHD 
#-Path "C:\VMs\VMMaster\VMMaster.vhdx"
#-SizeBytes 40GB
#
#New-VMSwitch
#-Name "VMSwitch"
#-SwitchType Internal
#
#Add-VMHardDiskDrive -VMName "VMMaster" -Path "C:\VMs\VMMaster\VMMaster.vhdx"
#Add-VMNetworkAdapter -VMName "VMMaster" -SwitchName "VMSwitch"

$osPath = "C:\Iso\ubuntu-22.04.4-desktop-amd64.iso"

$configurationLight = @{
    "core" = 2;
    "ram"  = 4GB
}

$configurationPower = @{
    "core" = 6;
    "ram"  = 8GB
}


$inventory = @(@{
        "vmName" = "VM-Master";
        "os"   = $osPath; 
        "ram"  = $configurationPower["ram"]; 
        "cpu"  = $configurationPower["core"];
        "size" = "80GB"
    }, 
    @{"vmName"   = "VM-CICDCD"; 
        "os"   = $osPath; 
        "ram"  = $configurationLight["ram"]; 
        "cpu"  = $configurationLight["core"];
        "size" = "80GB"
    }, 
    @{"vmName"   = "VM-Test"; 
        "os"   = $osPath; 
        "ram"  = "4GB"; 
        "cpu"  = "2";
        "size" = "80GB"
    }, 
    @{"vmName"   = "VM-Prod"; 
        "os"   = $osPath; 
        "ram"  = "4GB"; 
        "cpu"  = "2";
        "size" = "80GB"
    }, 
    @{"vmName"   = "VM-Monitoring"; 
        "os"   = $osPath; 
        "ram"  = "4GB"; 
        "cpu"  = "2";
        "size" = "80GB"
    })   

$vmDirectory = "C:\VM\VirtualMachines"
$virtualDiskDirectory = "C:\VM\VHDs"

foreach ($vmSpec in $inventory) {
    Write-Host "Create VM: $($vmSpec["vmName"])"
    $vmName = $vmSpec["vmName"]
    
    #creation VM
    New-VM -Name $vmName -Path $vmDirectory -Generation 2 -NoVHD
    
    #definition spec vm
    Set-VMMemory -VMName $vmName -StartupBytes $vmSpec["ram"]
    Set-VMProcessor -VMName $vmName -Count $vmSpec["cpu"]

    #creation lecteur DVD & montage ISO
    $dvdReader = Add-VMDvdDrive -VMName $vmName -Path  $vmSpec["os"]
    Set-VMFirmware -VMName $vmName -FirstBootDevice $dvdReader
    
    #creation disque dur virtuel
    $vhdPath = "$virtualDiskDirectory\$vmName\$($vmName).vhdx"
    New-VHD -Path $vhdPath -SizeBytes 40GB -Dynamic 
    Add-VMHardDiskDrive -VMName $vmName -Path $vhdPath
    Start-VM -VMName $vmName 
}

