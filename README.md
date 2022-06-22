# win_test

https://notes.ponderworthy.com/fsutil-tweaks-for-ntfs-performance-and-reliability


echo "ssd tweaks"
fsutil behavior set EncryptPagingFile 0
fsutil behavior set disabledeletenotify 0


## Install Windows Store

```powershell
wsreset -i 
```

### 7z
https://www.7-zip.org/

### Allow to execute scripts
```powershell
powershell "Set-ExecutionPolicy Unrestricted"

# undo
powershell "Set-ExecutionPolicy Default"
```


#Install WSL & reboot then

```powershell
wsl --set-default-version 2
wsl --update
wsl --shutdown
```


### Winget

```
winget upgrade --silent --all

$DesktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
winget list > "$DesktopPath\winget.txt"
```


https://cmder.net/
