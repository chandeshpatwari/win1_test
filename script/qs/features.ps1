$feature=@(
"NetFx3"
"Microsoft-Windows-Subsystem-Linux"
"VirtualMachinePlatform"
#"Microsoft-Hyper-V"
)
foreach ($opt in $feature)
{
dism /online /Enable-Feature /featurename:$opt /all /norestart
};
wsl --install
OptionalFeatures


<#
# gpedit(home edition)
$pkg=ls @(
"$env:windir\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package*.mum",
"$env:windir\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package*.mum"
)
$pkg | foreach { dism.exe /online /norestart /add-package:"$_"

# hyperV (home edition)
echo "checking virtmgmt"
$pkg=ls @(
"$env:windir\servicing\Packages\*Hyper-V*.mum"
)
$pkg | foreach { dism.exe /online /norestart /add-package:"$_" }
dism /online /Enable-Feature /featurename:"Microsoft-Hyper-V" /all /norestart
echo "Reboot to use Hyper V"
#>
