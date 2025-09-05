ssh -i ~/.ssh/id_ed25519 id_ed25519@4.250.120.147
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Fri Sep  5 10:49:05 UTC 2025

  System load:  0.0               Processes:             118
  Usage of /:   7.8% of 28.89GB   Users logged in:       0
  Memory usage: 38%               IPv4 address for eth0: 172.20.0.4
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

New release '24.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Fri Sep  5 10:33:05 2025 from 31.148.23.181
id_ed25519@MyVm:~$ 
logout
Connection to 4.250.120.147 closed.
❯ scripts/validate-artifacts.ps1
zsh: permission denied: scripts/validate-artifacts.ps1
❯ pwsh
PowerShell 7.5.2
PS /Users/litvi/Desktop/Azure/azure_task_4_reset_vm_password> scripts/validate-artifacts.ps1
Reading config
Checking if temp folder exists
Downloading artifacts
Validating artifacts
✅ Checked if Virtual Machine exists - OK.
✅ Checked Virtual Machine location - OK.
✅ Checked Virtual Machine availability zone - OK.
✅ Checked Virtual Machine security type settings - OK.
✅ Checked Virtual Machine OS image publisher - OK
✅ Checked Virtual Machine OS image offer - OK
✅ Checked Virtual Machine size - OK
✅ Checked Virtual Machine OS user authentification settings - OK
✅ Checked if the Public IP resource exists - OK
✅ Checked Public IP DNS label - OK
✅ Checked if the Network Interface resource exists - OK
✅ Checked if Public IP assigned to the VM - OK
✅ Checked if the Network Security Group resource exists - OK
✅ Checked if NSG has SSH network security rule configured - OK
✅ Checked if NSG has HTTP network security rule configured - OK
✅ Checked if VM admin password was reset - OK

🥳 Congratulations! All tests passed!