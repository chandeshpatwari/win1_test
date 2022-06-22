$dwdir="$Env:USERPROFILE\Downloads\qs"
mkdir $aria2dir

$wd=pwd
echo "Hello $Env:USERNAME"

$apps=@(
#"https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
"https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe"
"https://www.thewindowsclub.com/downloads/UWT4.zip"
)

foreach ($opt in $apps) {
 aria2c $opt -d $dwdir/Apps
}

$wd=pwd

$apps=@(
#"https://github.com/builtbybel/bloatbox"
#"https://github.com/builtbybel/privatezilla"
#"https://github.com/builtbybel/ThisIsWin11"
"https://github.com/builtbybel/CleanmgrPlus"
"https://github.com/Sophia-Community/SophiApp"
"https://github.com/hellzerg/optimizer"
"https://github.com/valinet/ExplorerPatcher"
)
$repo =$($apps -replace "https://github.com/","")
$api=foreach ($opt in $repo) {
 echo "https://api.github.com/repos/$opt/releases/latest" 
}

$links=$(cmd /c curl $api | findstr  "browser_download_url")
$appsln=$(Select-String 'https://[^\"]*' -Input $links -AllMatches).Matches.Value
$appsln
aria2c -Z $appsln -d $dwdir/Apps/tools/

$scripts=@(
#"https://github.com/Sycnex/Windows10Debloater/archive/refs/heads/master.zip"
#"https://github.com/W4RH4WK/Debloat-Windows-10/archive/refs/heads/master.zip"
#"https://github.com/Daksh777/windows10-debloat/archive/refs/heads/master.zip"
"https://github.com/ChrisTitusTech/win10script/archive/refs/heads/master.zip"
#"https://github.com/ChrisTitusTech/winutil/archive/refs/heads/master.zip"
"https://wpd.app/get/latest.zip"
)
echo $scripts
aria2c -Z $scripts -d $dwdir/Apps/scripts

cd $dwdir;explorer .
cd $wd
