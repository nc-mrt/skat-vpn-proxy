#Requires -RunAsAdministrator
param([String]$workDir=$pwd)

$name = "UFST VPN Proxy"

$startName = $name + " Start"

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$startName.lnk")
$Shortcut.IconLocation = "$workDir\vpn.ico"
$Shortcut.TargetPath = "$workDir\start.exe"
$Shortcut.WorkingDirectory = $workDir
$Shortcut.Save()
