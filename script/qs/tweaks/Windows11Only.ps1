#https://www.elevenforum.com/
#https://github.com/builtbybel/ThisIsWin11

echo "Disable New Context Menu"
mkdir -force "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" 
sp "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" "(Default)" ""

echo "Disable Widgets on Windows 11"
mkdir -f "HKLM:\SOFTWARE\Policies\Microsoft\Dsh"
sp "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" "AllowNewsAndInterests" 0

echo "Enable windows 10 command bar"
mkdir -force "HKCU:\Software\Classes\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}\InprocServer32"
sp "HKCU:\Software\Classes\CLSID\{d93ed569-3b3e-4bff-8355-3c44f6a52bb5}\InprocServer32" "(Default)" ""

echo "Remove System_requirements_not_met_watermark"
sp "HKCU:\Control Panel\UnsupportedHardwareNotificationCache" "SV1" "0"
sp "HKCU:\Control Panel\UnsupportedHardwareNotificationCache" "SV2" "0" 

##New BootAnimation
mkdir -f "HKLM:\System\ControlSet001\Control\BootControl"
sp "HKLM:\System\ControlSet001\Control\BootControl" "BootProgressAnimation" 1






