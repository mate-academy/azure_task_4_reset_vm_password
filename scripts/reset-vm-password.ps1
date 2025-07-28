param(
    [string]$ResourceGroupName,
    [string]$VMName,
    [string]$UserName,
    [string]$Password
)

Write-Host "🔄 Resetting password for VM $VMName in resource group $ResourceGroupName..."

Set-AzVMAccessExtension -ResourceGroupName $ResourceGroupName `
                        -VMName $VMName `
                        -Name "resetAccess" `
                        -Location "uksouth" `
                        -UserName $UserName `
                        -Password $Password `
                        -Publisher "Microsoft.OSTCExtensions" `
                        -Type "VMAccessForLinux" `
                        -TypeHandlerVersion "1.5"

Write-Host "✅ Password reset complete."

