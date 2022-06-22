echo @( "https://winstall.app/" 
"https://winget.run/"
"") > install.ps1

$vcc_ver = @(
"2005"
"2008"
"2010"
"2012"
"2013"
"2015-2022"
)

$softwares = @(
"7zip.7zip"
"peazip"
"Notepad++.Notepad++"
"Glarysoft.GlaryUtilities"
"REALiX.HWiNFO"
"Telegram.TelegramDesktop"
"Mozilla.Firefox"
"Alacritty.Alacritty"
"BraveSoftware.BraveBrowser"

#"agalwood.Motrix"
#"ClamWin.ClamWin"
)

foreach ($opt in $vcc_ver)
{
echo "winget install Microsoft.VC++${opt}Redist-x86" >>install.ps1
echo "winget install Microsoft.VC++${opt}Redist-x64" >>install.ps1
}



foreach ($opt1 in $softwares) 
{
echo "winget install $opt1" >>install.ps1
}

notepad ./install.ps1
clear
