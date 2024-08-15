<# 
Fikseerib VM rollide paiknevuse Hyper-V klastri hostidel ning taastab (Live Migrate) selle seisu 
pärast nende rollide liigutamisi (näiteks hostide uuendamine jmt)

Vajab moodulit: FailoverClusters
Paigalda: Add-WindowsFeature RSAT-Clustering-PowerShell
Käivita see skript mõnel Hyper-V klastri liikmel
#>

# Fikseeri VM'ide paiknevus enne tegevusi
$CSVpath = 'C:\Temp\1.txt'
Get-ClusterGroup | where GroupType -eq "VirtualMachine" | select Name,OwnerNode | Export-Csv -NoTypeInformation -Path $CSVpath

Write-Host "Tegevuste aeg (---või poolita skript siit, et vältida fikseeritud seisu üle kirjutamine---)"
pause

# Taasta VM'ide paiknevus, mis oli enne tegevusi
$VMs = Import-Csv $CSVpath

foreach ($VM in $VMs) {
    Move-ClusterVirtualMachineRole -Name (Get-ClusterGroup -Name $VM.Name) -Node (Get-ClusterNode $VM.OwnerNode) -WarningAction Ignore -ErrorAction Ignore
    }
