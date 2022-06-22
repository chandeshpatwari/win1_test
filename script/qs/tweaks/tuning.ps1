Get-MMAgent
Disable-MMAgent -ApplicationPreLaunch
Disable-MMAgent -MemoryCompression

#Disable Prefetch
#0 Disable ;1 Application ;2 Boot ;3 1&2 
sp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" 0 
sp "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" 0 

echo "Disabling service SysMain (former Superfetch) in case it's not used."
Get-Service "SysMain" | Set-Service -StartupType Manual -PassThru | Stop-Service
Get-MMAgent
