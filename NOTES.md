# Azure Task 4 — UK South VM Size Limitation

## Summary

I completed the VM admin password reset task and verified that password-based SSH authentication works correctly.

However, the validation script fails because it requires the VM to be deployed in the `UK South` region.

My Azure subscription does not allow the VM sizes permitted by the course in `UK South`, so I used `Standard_B2ats_v2` in `West US 2`, where it is available.

---

## Password Reset Verification

The original VM admin user is:

```text
alexey
```

The new user created during the password reset is:

```text
alex
```

This satisfies the requirement to use a username different from the original VM admin user.

The Azure VM Access extension is installed successfully:

```text
Name              : enablevmAccess
Publisher         : Microsoft.OSTCExtensions
ExtensionType     : VMAccessForLinux
ProvisioningState : Succeeded
```

The VM was originally created with password authentication disabled in the Azure OS profile:

```text
DisablePasswordAuthentication : True
```

After the password reset, the effective SSH configuration inside Ubuntu shows:

```text
passwordauthentication yes
```

Checked with:

```bash
sudo sshd -T | grep -i passwordauthentication
```

I also successfully connected to the VM from my local machine using the new username and password:

```bash
ssh alex@<PUBLIC_IP>
```

SSH requested the password and the login completed successfully.

---

## Validation Script Result

The validation script confirms that the VM exists, but then stops because the VM is not deployed in `UK South`:

```text
✅ Checked if Virtual Machine exists - OK.

Virtual is not deployed to the UK South region.
Please re-deploy VM to the UK South region and try again.
```

Command used:

```powershell
.\scripts\validate-artifacts.ps1
```

---

## VM Size Availability in UK South

The course requires `Standard_B1s`, but also allows alternative VM sizes such as:

- `Standard_B2ats_v2`
- `Standard_B2pts_v2`

I checked all three sizes in `UK South` with:

```powershell
Get-AzComputeResourceSku -Location "uksouth" |
    Where-Object {
        $_.ResourceType -eq "virtualMachines" -and
        $_.Name -in @(
            "Standard_B1s",
            "Standard_B2ats_v2",
            "Standard_B2pts_v2"
        )
    } |
    ForEach-Object {
        Write-Host "`n===== $($_.Name) ====="
        $_.Restrictions | Format-List Type, ReasonCode, RestrictionInfo, Values
    }
```

Azure returned the following restrictions:

```text
===== Standard_B1s =====

Type            : Location
ReasonCode      : NotAvailableForSubscription
RestrictionInfo : Microsoft.Azure.Management.Compute.Models.ResourceSkuRestrictionInfo
Values          : {uksouth}

Type            : Zone
ReasonCode      : NotAvailableForSubscription
RestrictionInfo : Microsoft.Azure.Management.Compute.Models.ResourceSkuRestrictionInfo
Values          : {uksouth}


===== Standard_B2ats_v2 =====

Type            : Location
ReasonCode      : NotAvailableForSubscription
RestrictionInfo : Microsoft.Azure.Management.Compute.Models.ResourceSkuRestrictionInfo
Values          : {uksouth}

Type            : Zone
ReasonCode      : NotAvailableForSubscription
RestrictionInfo : Microsoft.Azure.Management.Compute.Models.ResourceSkuRestrictionInfo
Values          : {uksouth}


===== Standard_B2pts_v2 =====

Type            : Location
ReasonCode      : NotAvailableForSubscription
RestrictionInfo : Microsoft.Azure.Management.Compute.Models.ResourceSkuRestrictionInfo
Values          : {uksouth}

Type            : Zone
ReasonCode      : NotAvailableForSubscription
RestrictionInfo : Microsoft.Azure.Management.Compute.Models.ResourceSkuRestrictionInfo
Values          : {uksouth}
```

This means that all VM sizes allowed by the course are unavailable for my subscription in the `UK South` region.

---

## Additional B-Series Check

I also checked whether any unrestricted B-series VM size is available to my subscription in `UK South`:

```powershell
Get-AzComputeResourceSku -Location "uksouth" |
    Where-Object {
        $_.ResourceType -eq "virtualMachines" -and
        $_.Name -like "Standard_B*" -and
        $_.Restrictions.Count -eq 0
    } |
    Select-Object Name |
    Sort-Object Name
```

The command returned no results.

So there are currently no unrestricted B-series VM sizes available to my subscription in `UK South`.

---

## Current Deployment

Because of this subscription limitation, I deployed the VM with:

```text
Region:  West US 2
VM size: Standard_B2ats_v2
```

The VM itself works correctly, and the password reset requirement has been completed and tested successfully.

---

## Question for Review

The validator requires:

```text
Region = UK South
```

but my Azure subscription reports:

```text
ReasonCode = NotAvailableForSubscription
```

for all VM sizes permitted by the course in that region.

Could you please confirm one of the following:

1. whether using another Azure region is acceptable for this task;
2. whether another VM size can be used in `UK South`; or
3. whether the validator can be adjusted for subscriptions where the required VM sizes are unavailable in `UK South`.

At the moment, I cannot satisfy both the validator's region requirement and the course's VM size requirements with this Azure subscription.
