# Laptop Warranty Tracker

$Devices = Import-Csv ".\Warranty.csv"

$Today = Get-Date

$WarrantyReport = foreach ($Device in $Devices)
{
    $ExpiryDate = [datetime]$Device.WarrantyExpiry

    $DaysRemaining = ($ExpiryDate - $Today).Days

    [PSCustomObject]@{
        SerialNumber   = $Device.SerialNumber
        User           = $Device.User
        Model          = $Device.Model
        DeploymentDate = $Device.DeploymentDate
        WarrantyExpiry = $Device.WarrantyExpiry
        DaysRemaining  = $DaysRemaining
    }
}

$ExpiringDevices = $WarrantyReport |
Where-Object { $_.DaysRemaining -le 90 }

Write-Host ""
Write-Host "Devices Expiring Within 90 Days"
Write-Host "--------------------------------"

$ExpiringDevices | Format-Table

$ExpiringDevices |
Export-Csv ".\WarrantyReport.csv" -NoTypeInformation

Write-Host ""
Write-Host "Warranty Report Generated Successfully"
