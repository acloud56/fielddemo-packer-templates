# Basic configuration of vanilla Windows Server installation to progress Packer.io builds
# @author Michael Poore
# @website https://blog.v12n.io
# @source https://github.com/virtualhobbit
$ErrorActionPreference = "Stop"

# Switch network connection to private mode
# Required for WinRM firewall rules
$profile = Get-NetConnectionProfile
Set-NetConnectionProfile -Name $profile.Name -NetworkCategory Private

# Enable WinRM service
winrm quickconfig -quiet
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'

# Reset auto logon count
# https://docs.microsoft.com/en-us/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-autologon-logoncount#logoncount-known-issue
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

# Configure Disks
new-partition -disknumber 1 -usemaximumsize | format-volume -filesystem NTFS -newfilesystemlabel Data
get-partition -disknumber X | set-partition -newdriveletter D
new-partition -disknumber 2 -usemaximumsize | format-volume -filesystem NTFS -newfilesystemlabel PageFile
get-partition -disknumber X | set-partition -newdriveletter P
