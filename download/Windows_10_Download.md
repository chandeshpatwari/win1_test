#  Download

> Scrrol Down for LTSC

####  From the Micosoft Site
- Goto [Windows 10](https://www.microsoft.com/en-in/software-download/windows10ISO)
#### If on windows :
```
- Hit F12 or, Right Click --> Inspect Element
- Ctrl+Shift+M 
- Click on the Responsive button on the toolbar & select iPad Pro/iPad 
- Refresh the Page (Hit F5)
- Hit F12 to close in Developer tools.
```

-  From the DropDown Menu
```
Select edition > Confirm
Select the Product "Language" > Confirm
```
- Below the Windows 10 <Language>
`Click` on `[64-bit Download]`

- Click on `+ Verify your download` just below `[64-bit Download]` & **Follow the tutorial** 
> **or** if you are noob. then
- Copy the SHA256 `hash` for `<Language> 64-bit` to a text file.

#####  From Microsoft via TechBench by WZT
1. Open : [TechBench by WZT](https://tb.rg-adguard.net/)
2. Select type: Windows (Final)
3. Select version: e.g- Windows 10, Version 21H2 (build 19044.1288) 
4. Select edition: "Windows 10"
5. Select language:
6. Select file: _x64 ISO file.
7. Click `Download`
8. Copy SHA1 value in a text file (available below the Download button)
> Link should match https://software.download.prss.microsoft.com/

#### Using Fido
[Fido](https://github.com/pbatard/Fido)


#  Verify On Windows
  
SHA256 (From Microsoft) | SHA1 via (tb.rg-adguard.net)
  
- Navigate to the folder with the iso image
- Open PowerShell there

```
Get-FileHash ISO_FILE.iso -Algorithm SHA256 
Get-FileHash  ISO_FILE.iso -Algorithm SHA1 
```
```
Get-FileHash  ./Win10_21H2_English_x64.iso -Algorithm SHA256  |ft -HideTableHeaders -Property *
```

#### GUI Method
- Install [7-zip](https://www.7-zip.org/)
- Right click on the `ISO_FILE.iso`
- `7z > CRC SHA > SHA-256`
- `7z > CRC SHA > SHA-1`

> If the SHA hashes match, the file has not been corrupted, tampered with or altered from the original.


#  Verify On Linux
- Open Terminal & Navigate to the folder with the iso image.
```
$ sha256sum ISO_FILE.iso
$ sha1sum ISO_FILE.iso
```
> If the SHA hashes match, the file has not been corrupted, tampered with or altered from the original.


# LTSC
  
```
https://pastebin.com/raw/MDQS8Gve

https://www.reddit.com/r/Windows10LTSC/comments/qvf2ej/ltsc_2021_iso/

https://cloud.mail.ru/public/SVLy/hAp8JqCQD

https://forums.mydigitallife.net/threads/discussion-windows-10-final-build-19041-2-3-4-pc-20h1-2-21h1-2-vb_release.80763/page-439#post-1705312

https://isofiles.bd581e55.workers.dev/Windows%2010/Windows%2010%20Enterprise%20LTSC%202021/
```





