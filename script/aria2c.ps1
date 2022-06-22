$aria2dir="$Env:USERPROFILE\QSapps\aria"
mkdir $aria2dir
$aria=$(cmd /c curl https://api.github.com/repos/aria2/aria2/releases/latest| findstr "browser_download_url" | findstr win-64bit)
$ln=$(Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $aria).Matches.Value
wget $ln -OutFile aria2.zip
Expand-Archive -Path .\aria2.zip -Force;mv .\aria2\*\aria2c.exe $aria2dir

echo "add this to path variable"
echo $aria2dir
sysdm.cpl
rm -r aria2,aria2.zip
ls $aria2dir
