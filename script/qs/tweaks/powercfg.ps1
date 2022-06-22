# Disable "Hibernate" & "Fast Boot"
mkdir -f "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager\Power"
sp "HKLM:SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" 0
powercfg -h off

# AutoLock Timeout
sp "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "InactivityTimeoutSecs" 900

# Set PowerPlan

#$powerPlan = 'e9a42b02-d5df-448d-aa00-03f14749eb61'	# (Ultimate Performance)
$powerPlan = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'	# (High performance)
#$powerPlan = '381b4222-f694-41f0-9685-ff5bb260df2e'	# (Balanced)
#$powerPlan = 'a1841308-3541-4fab-bc81-f71556f20b4a'	# (Power saver)

powercfg -duplicatescheme $powerPlan
PowerCfg -SetActive $powerPlan
write-Host -ForegroundColor Green "PowerScheme Sucessfully Applied"

# Tweak powerplan
<#
$diskAcTimeout = 0
$diskDcTimeout = 0
$monitorAcTimeout = 10
$monitorDcTimeout = 5
$standbyAcTimeout = 0
$standbyDcTimeout = 25
$hybernateAcTimeout = 0
$hybernateDcTimeout = 0

powercfg.exe -x -monitor-timeout-ac $monitorAcTimeout
powercfg.exe -x -monitor-timeout-dc $monitorDcTimeout
powercfg.exe -x -disk-timeout-ac $diskAcTimeout
powercfg.exe -x -disk-timeout-dc $diskDcTimeout
powercfg.exe -x -standby-timeout-ac $standbyAcTimeout
powercfg.exe -x -standby-timeout-dc $standbyDcTimeout
powercfg.exe -x -hibernate-timeout-ac $hybernateAcTimeout
powercfg.exe -x -hibernate-timeout-dc $hybernateDcTimeout
#>

powercfg.exe -L


