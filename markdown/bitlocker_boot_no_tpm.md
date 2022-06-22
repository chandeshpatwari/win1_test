## Check if TPM enabled.

```powershell
tpm.msc
```

> Enable it via BIOS settings if available.

## Allow bitlocker without TPM module( if TPM unavailable)
```
gpedit.msc
```
Local Computer Policy > Computer Configuration > 
Administrative Templates > Windows Components > 
BitLocker Drive Encryption > Operating System Drives

**Click** on "Require additional authentication at startup"

**Click** `Enabled` at the top of the window
and **tick** the "Allow BitLocker without a compatible TPM (requires a password or a startup key on a USB flash drive)" > OK


## Enable Bitlocker

Open explorer > Right Click `Local Disk(C):` > Turn on BitLocker > Choose unlock Method `Enter a password` > Enter password > Backup the Recover Key >
Choose how much of Drive to Encrypt > Choose New Encryption Method > Click Start Encrypting > Click Continue

System will now restart and ask for password > Enter the passowrd > System will boot and encryption starts.


### Modern Passowrd Prompt

```
bcdedit
bcdedit /set "{default}" bootmenupolicy standard
bcdedit /set "{current}" bootmenupolicy standard
```
### Legacy Passowrd Prompt

```
bcdedit
bcdedit /set "{default}" bootmenupolicy legacy
bcdedit /set "{current}" bootmenupolicy legacy
```

https://www.howtogeek.com/howto/6229/how-to-use-bitlocker-on-drives-without-tpm/

https://www.intowindows.com/how-to-enable-or-disable-graphical-boot-menu-in-windows-10/
