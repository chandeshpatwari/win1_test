# Ventoy

- [Download](https://github.com/ventoy/Ventoy/releases)

- [Install](https://github.com/ventoy/Ventoy#document)

# Ventoy for Linux

#### Download

```
mkdir ventoy && cd ventoy
wget $(curl https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep "browser_download_url" |grep "linux.tar.gz\|sha256.txt" | egrep -o 'https?://[^ ")]+')
```

#### Extract

```
mkdir ventoy
tar -xvf *-linux.tar.gz -C ventoy
cd ventoy/*
./VentoyGUI.$(uname -m)
```
#### Install Ventoy

#### Copy the ISOs to USB Drive & install


# Ventoy for Windows 

#### Download
- [Download](https://github.com/ventoy/Ventoy/releases)

#### Extract

#### Install
execute `Ventoy2Disk.exe` and install

#### Copy the ISOs to USB Drive & install


> For help go to:

https://github.com/ventoy/Ventoy#document
