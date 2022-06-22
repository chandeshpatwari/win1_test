#### Using [Rufus](https://rufus.ie/en/) ,windwows only
- Downlaod Rufus : https://github.com/pbatard/rufus/releases
- Select Device:USB Drive you wanna use
- Boot Selection:Disk or ISO image |Select
- Navigate | Select | Open
- Image Option:Standard Image Installation
- Partition Scheme:GPT | Target System:UEFI(non CSM) | File System:NTFS
- START
- I'm [Stupid](https://www.youtube.com/watch?v=VsSvD-SIqiQ)
- 
#### Using  [balenaEthcher](https://www.balena.io/etcher/) (Windows/Linux)
- Download Ethcher: https://github.com/balena-io/etcher/releases
- Howto: https://docs.01.org/clearlinux/latest/get-started/bootable-usb.html
- Youtube : https://www.youtube.com/watch?v=WGq2WM-JAkw

#### Get Option to choose edition
- After Flashing to ISO
- goto USB:/sources/ folder

> On Windows
- Create New text file ei.cfg
- Edit it with
```
[Channel]
Retail
```
> On Linux
 Goto the Source Folder in the Prepared USB(Installation Media) & Open Terminal
```
echo "[Channel]" > ei.cfg
echo "Retail">> ei.cfg
```