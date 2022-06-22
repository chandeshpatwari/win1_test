# Privilege Escalation
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}



# Explorer

echo "Tweaking explorer"
$key = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
sp $key "LaunchTo" 1
sp $key	"Hidden" 1
sp $key "HideFileExt" 0	
sp $key "HideDrivesWithNoMedia" 0
sp $key "ShowSyncProviderNotifications" 0
sp $key "AutoCheckSelect" 0
sp $key "SeparateProcess" 0	
sp $key "IconsOnly" 0	
sp $key "EnableAutoTray" 1
sp $key "Start_SearchFiles" 0 # 0,1,2	

echo "Clear last used files and folders"
rm -r $env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*.automaticDestinations-ms -FORCE -ErrorAction SilentlyContinue
rm -r $env:APPDATA\Microsoft\Windows\Recent\* -FORCE -ErrorAction SilentlyContinue

echo "Hide Frequently and Recently Files"
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 0
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 0

echo "Remove 3D Objects from This PC"
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"

echo "Disable Share in context menu"
mkdir -f "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" ""

# UI

echo "Disable News and Interests on Taskbar in Windows 10"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" "EnableFeeds" 0

echo "General Customisation"
mkdir -f "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$GC="HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
sp $GC "ColorPrevalence" 0
sp $GC "EnableTransparency" 1
sp $GC "AppsUseLightTheme" 0
sp $GC "SystemUsesLightTheme" 0

echo "Maximize wallpaper quality" 
sp "HKCU:\Control Panel\Desktop" "JPEGImportQuality" 100

echo "Volume Mixer" # Old Style:0
mkdir -f "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC"
sp "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" "EnableMtcUvc" 1


# Performence

echo "Disable Virtualization Based Security (VBS), Credential Guard and HVCI."
# VBS enhances system security, but is known to cause some performance issues on older systems.
sp "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" "EnableVirtualizationBasedSecurity" 0
mkdir -f "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
sp "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" "Enabled" 0
mkdir -f "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard"
sp "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard"  "Enabled" 0

echo "NTFS filesystem tweaks"
#https://notes.ponderworthy.com/fsutil-tweaks-for-ntfs-performance-and-reliability
#https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/fsutil-behavior
fsutil 8dot3name set 1
fsutil behavior set memoryusage 2
fsutil behavior set disablelastaccess 1
fsutil repair set C: 0x01
fsutil resource setautoreset true C:\
fsutil resource setconsistent C:\
fsutil resource setlog shrink 10 C:\
fsutil behavior set mftzone 2
echo "Disable NTFS Long File Path"
sp "HKLM:SYSTEM\CurrentControlSet\Control\FileSystem"  "LongPathsEnabled"  0

echo "ssd tweaks"
fsutil behavior set EncryptPagingFile 0
fsutil behavior set disabledeletenotify 0
powercfg -h off # Disable Hibernation

echo "Auto-end non responsive tasks " # enable: 1
sp "HKCU:\Control Panel\Desktop" "AutoEndTasks" 0

#Join svchost
#https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
$mem=(Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1KB
sp "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" $mem


# Quality of Life

echo "Set clock to UTC, prevents time issues when dual booting Linux/OSX systems.(fixes issues with ntp)"
sp "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" "RealTimeIsUniversal" 1

enable "Bluetooth Quick Pair"
mkdir -f "HKCU:\Software\Microsoft\Windows\CurrentVersion\Bluetooth"
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Bluetooth" "QuickPair" 1

echo "God Mode has been enabled, check out the new link on your Desktop"
$DesktopPath = [Environment]::GetFolderPath("Desktop");
mkdir "$DesktopPath\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"

Write-Output "Disable easy access keyboard stuff"
sp "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"
sp "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122"
sp "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"

echo "Disable INK"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace"
sp "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0

# Security
echo "enable UAC" # disable: 0
sp "HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system" "EnableLUA" 1

echo "Disable LLMNR"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" "EnableMulticast" 0
ipconfig /flushDNS

echo "Disable NetBIOS over TCP/IP service"
sp "HKLM:\SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces\tcpip*" NetbiosOptions 2
#sp "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT" "Start" 4

echo "Disable Memory Dump"
sp "HKLM:\System\CurrentControlSet\Control\CrashControl" "CrashDumpEnabled" "0"

echo "Disable ShadowCopy" # Disables system Restore function
#vssadmin delete shadows /all /quiet | Out-Null


# Gaming

#Hardware Accelerated GPU Scheduling set to ON (2) may improve latency #OFF(1)
echo "Enabling Hardware Accelerated GPU Scheduling"
sp "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" 2	


# Privacy


#https://github.com/undergroundwires/privacy.sexy

echo "Disable Telemetry"
echo "Disabling telemetry via Group Policies"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
mkdir -f "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0
mkdir -force "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection"
sp "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0

echo "Disable Customer Experience Improvement Program"
mkdir -f  "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
sp "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" "CEIPEnable" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient" "CorporateSQMUR" "0.0.0.0"

echo "Disable Application Impact Telemetry"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "AITEnable" 0

echo "Disable Inventory Collector" 
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "DisableInventory" 1

echo "Disable Problem Steps Recorder"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "DisableUAR" 1

echo "Disable Advertising ID"
mkdir -f "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" "DisabledByGroupPolicy" 1

echo "Disabling keylogger" 
mkdir -f "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports"
sp "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
sp "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1
sp "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "HarvestContacts" 0
sp "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" "HarvestContacts" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC" "PreventHandwritingDataSharing" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" "PreventHandwritingErrorReports" 1

echo "Disabling browser language access"
sp "HKCU:\Control Panel\International\User Profile" "HttpAcceptLanguageOptOut" 1

echo "Disabling Wi-Fi Sense"
mkdir -f "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
mkdir -f "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
mkdir -f "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
sp "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" "Value" 0 
sp "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" "Value" 0 
sp "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" "AutoConnectAllowedOEM" 0 

echo "Disabling Location Tracking"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation"1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocationScripting" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableSensors" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableWindowsLocationProvider" 1


echo "Disabling Delivery Optimisation"
#(0=off, 1=local network only, 2=On,local network private peering only,3=local network and Internet,99=simply download mode,100=bypass mode)

mkdir -f "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization"
mkdir -f "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" "SystemSettingsDownloadMode" 0
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "SystemSettingsDownloadMode" 0


echo "Disabling Windows Error Reporting"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting"
sp "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" "Disabled" 1
sp "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" "Disabled" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" 1

echo "Prevent bloatware applications from returning and remove Start Menu suggestions"               
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1 
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableThirdPartySuggestions" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableTailoredExperiencesWithDiagnosticData" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" 1

echo "Prevent Apps from re-installing"
$cdm = @(
"ContentDeliveryAllowed"
"FeatureManagementEnabled"
"OemPreInstalledAppsEnabled"
"PreInstalledAppsEnabled"
"PreInstalledAppsEverEnabled"
"RotatingLockScreenEnabled"
"RotatingLockScreenOverlayEnabled"
"SilentInstalledAppsEnabled"
"SlideshowEnabled"
"SoftLandingEnabled"
"SystemPaneSuggestionsEnabled"
)
mkdir -f  "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
foreach ($key in $cdm) {
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" $key 0
}

echo "Disable ads on lock screen" 
$cdm1 = @(
"ActionText"
"ActionUri"
"ClickthroughToken"
"CreativeId"
"CreativeJson"
"DescriptionText"
"HotspotImageFolderPath"
"ImpressionToken"
"LandscapeAssetPath"
"PlacementId"
"PortraitAssetPath"
)
mkdir -f "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative"
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" "LockImageFlags" 0
foreach ($key in $cdm1) {
sp "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" $key ""
}

echo "Disable File History"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\FileHistory" 
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\FileHistory" "Disabled" 1

echo "Disable Active Help" 
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" "NoActiveHelp" 1

echo "Disable loggers" 
mkdir -f "HKLM:\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener"
mkdir -f "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener"
sp "HKLM:\SYSTEM\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" "Start" 0
sp "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" "Start" 0
sp "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" "Start" 0

echo "Disable Windows Feedback"
mkdir -f "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
sp "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0
sp "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "PeriodInNanoSeconds" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "DoNotShowFeedbackNotifications" 1

echo "Disable Microsoft Help feedback" 
mkdir -f "HKCU:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0"
sp "HKCU:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" "NoExplicitFeedback" 1

echo "Disable Send inking and typing data to Microsoft" 
sp "HKLM:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0
sp "HKCU:\SOFTWARE\Microsoft\Input\TIPC" "Enabled" 0

echo "Disable Improve inking and typing recognition"
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" "AllowLinguisticDataCollection" 0

echo "Disable Windows Insider Program"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" "AllowBuildPreview" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" "EnableConfigFlighting" 0

echo "Disable AutoPlay and AutoRun"
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 255
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoAutorun" 1

echo "Disable Remote Assistance"
sp "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" 0
sp "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowFullControl" 0

echo "Disable solicited Remote assistance"
sp "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" "fAllowToGetHelp" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" "fEncryptRPCTraffic" 1
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" "fDisableCdm" 1

echo "Disable administrative shares"
sp "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "AutoShareWks" 0

echo "Do not send Windows Media Player statistics"
mkdir -f "HKCU:\SOFTWARE\Microsoft\MediaPlayer\Preferences"
sp "HKCU:\SOFTWARE\Microsoft\MediaPlayer\Preferences" "UsageTracking" 0

echo "Disable Automatic Sample Submission in Windows Defender"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SpynetReporting" 0
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" 2

echo  "Turn on SmartScreen Filter to check web content"
sp "HKCU:\Software\Microsoft\Edge\SmartScreenEnabled" "(Default)" 1
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 1
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost" "PreventOverride" 0
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "EnableWebContentEvaluation" 1
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" "PreventOverride" 0
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "SmartScreenEnabled" "Warn"
sp "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer" "SmartScreenEnabled" "Warn"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableSmartScreen" 1 

echo "Disable Bing Search in Start Menu"
mkdir -f "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
sp "HKCU:\Software\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" 1 
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0

echo "Defuse Windows search settings"
Set-WindowsSearchSetting -EnableWebResultsSetting $false

echo "Locaton aware printing (changes default based on connected network)"
mkdir -force "HKCU:\Printers\Defaults"
sp "HKCU:\Printers\Defaults" "NetID" "{00000000-0000-0000-0000-000000000000}"

echo "Set Network to Public(less exposed)"
#Set-NetConnectionProfile -NetworkCategory Private
Set-NetConnectionProfile -NetworkCategory Public

echo "Disabling Windows save zone information..." #aka Block Files Downloaded from Internet.
mkdir -f "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments"
mkdir -f "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments"
sp "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" "SaveZoneInformation" 1
sp "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" "SaveZoneInformation" 1

echo "removing SMBv1"
Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
Get-SmbServerConfiguration | Select EnableSMB1Protocol
Set-SmbServerConfiguration -EnableSMB1Protocol $false
Get-SmbServerConfiguration | Select EnableSMB2Protocol
Set-SmbServerConfiguration -EnableSMB2Protocol $false
gp HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters
sp "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "SMB1" 0 
sp "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "SMB2" 0

# Updates

Write-Output "Disable seeding of updates to other computers via Group Policies"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0





















