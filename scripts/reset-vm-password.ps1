param(
    [string]$ResourceGroupName = "mate-azure-task-2",
    [string]$VMName = "task2-vm",
    [string]$NewUsername = "azureuser2",
    [securestring]$NewPassword = (Read-Host -Prompt "Enter password for '$NewUsername'" -AsSecureString),
    [switch]$StopVMAfterValidation
)

$ErrorActionPreference = "Stop"
$plainPassword = (New-Object PSCredential "x", $NewPassword).GetNetworkCredential().Password

$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName

# 1. Reset the admin password for a different (new) user via the VMAccess extension
Write-Output "Resetting password for user '$NewUsername' on VM '$VMName'..."
Set-AzVMAccessExtension `
    -ResourceGroupName $ResourceGroupName `
    -VMName $VMName `
    -Location $vm.Location `
    -Name "VMAccessForLinux" `
    -TypeHandlerVersion "1.5" `
    -ProtectedSettingString (@{ username = $NewUsername; password = $plainPassword } | ConvertTo-Json) | Out-Null
Write-Output "Password reset complete."

# 2. Resolve the VM's public FQDN and verify SSH access with the new credentials
$nic = Get-AzNetworkInterface -ResourceGroupName $ResourceGroupName | Where-Object { $_.VirtualMachine.Id -eq $vm.Id }
$pipName = Split-Path $nic.IpConfigurations[0].PublicIpAddress.Id -Leaf
$fqdn = (Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $pipName).DnsSettings.Fqdn

$sshCommand = "ssh $NewUsername@$fqdn `"echo PASSWORD_RESET_OK`""
if (Get-Command sshpass -ErrorAction SilentlyContinue) {
    Write-Output "Verifying SSH login as '$NewUsername'@$fqdn..."
    $result = sshpass -p $plainPassword ssh -o StrictHostKeyChecking=accept-new "$NewUsername@$fqdn" "echo PASSWORD_RESET_OK"
    if ($result -match "PASSWORD_RESET_OK") {
        Write-Output "SSH connectivity verified - password reset works."
    } else {
        throw "SSH verification failed: $result"
    }
} else {
    Write-Output "sshpass not available on this machine - run this command manually to verify: $sshCommand"
}

# 3. Optionally stop the VM once validation has passed (run with -StopVMAfterValidation when ready)
if ($StopVMAfterValidation) {
    Write-Output "Stopping VM '$VMName'..."
    Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force
    Write-Output "VM stopped."
} else {
    Write-Output "Skipping VM shutdown (pass -StopVMAfterValidation to stop it after the solution is reviewed)."
}
