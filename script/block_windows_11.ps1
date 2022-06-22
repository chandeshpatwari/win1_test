$key="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
mkdir -f $key
sp $key "ProductVersion" "Windows 10"
sp $key "TargetReleaseVersion" 1
sp $key "TargetReleaseVersionInfo" "21H2"

#Undo
#$key="HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
#rp $key "ProductVersion","TargetReleaseVersion","TargetReleaseVersionInfo"
