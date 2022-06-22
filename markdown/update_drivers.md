### Update all the drivers via Windows update.

### Update the Drivers From OEM

```
ark.intel.com
support.hp.com/us-en/drivers
pcsupport.lenovo.com
```

### Update using Third Party Tools
```
https://www.iobit.com/en/driver-booster.php
https://www.snappy-driver-installer.org/
https://sourceforge.net/projects/snappy-driver-installer-origin/
https://sdi-tool.org/
```

### GPU

<details><summary>Check GPU Vendor via powershell</summary>
<p>

```powershell
foreach ($gpu in Get-WmiObject Win32_VideoController) 
{
 Write-Host $gpu.Name
 Write-Host $gpu.Description
}
```

</p>
</details>

<details><summary>GPU resource</summary>
<p>

- AMD

```
amd.com/en/support
```

- Intel

```
intel.com
ark.intel.com
microsoft.com/store/productId/9PLFNLNT3G5G
```
- NVIDIA

```
nvidia.com/en-us/geforce/geforce-experience/
nvidia.com/en-us/geforce/drivers/
nvidia.com/Download/index.aspx

microsoft.com/store/productId/9NF8H0H7WMLT
```

</p>
</details>

#### Directx 
```
https://www.microsoft.com/en-us/download/details.aspx?id=35
https://www.microsoft.com/en-us/download/details.aspx?id=8109
https://aka.ms/directx_x86_appx
https://aka.ms/directx_x64_appx
```
