### Get edition selection during installation (Skip for LTSC)

> If Using Debian/Ubuntu/Mint
```
# sudo apt-get install aria2 genisoimage
```
> If you use Arch
```
# sudo pacman -S aria2 cdrtools
```

### Adding ei.cfg to Select Edition

- Open a termianl & Navigate to the folder where ISO is stored

```
mkdir Winiso
cp Win*.iso Winiso
cd Winiso 
```
```
mkdir iso
mkdir win-o
mkdir win-1
```
```
sudo mount -o uid=$(id -u),gid=$(id -g),loop Win*.iso win-o
ls -l windows-otmp
rsync -r --progress  win-o/* win-1
ls -l  win-1
chmod -R 777 win-1
echo "[Channel]"> win-1/sources/ei.cfg 
echo "Retail">>  win-1/sources/ei.cfg
cat  win-1/sources/ei.cfg
sudo umount win-o
```
### Build ISO
```
mm=$(ls Win*.iso)
mkisofs -b "boot/etfsboot.com" --no-emul-boot \
    --eltorito-alt-boot -b "efi/microsoft/boot/efisys.bin" --no-emul-boot \
    --udf -allow-limited-size -iso-level 3 --hide "*" -V "WindowsISO" -o ./iso/$RANDOM$(echo $mm) ./win-1

```
```
rm -rf win-o
rm -rf win-1
```
- Newly Built ISO is in iso folder
- & Can be used with Ventoy/Rufus/Etcher


> Ref
```
4chan.org/g/fwt
https://rentry.org/windows_for_retards
https://rentry.org/fwt
```