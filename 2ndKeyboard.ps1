# 2nd Keyboard Installer by futami

Write-Host "--------------------------------------------" -ForegroundColor Cyan
Write-Host "2nd Keyboard Installer by Futami" -ForegroundColor Cyan
Write-Host "--------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# Check if the script is running as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  Write-Host "Please run this script as an administrator" -ForegroundColor Red
  return
}

# Install Intercept
Write-Host "Installing Intercept..." -ForegroundColor Green
Write-Host ""
# Get quesion about intercept
Write-Host "HOLD UP!!" -ForegroundColor Red
Write-Host "Intercept only support up to 10 HID keyboard" -ForegroundColor Cyan
Write-Host "It is recommended to use at least 4 keyboards or below" -ForegroundColor Cyan
$answer = Read-Host "Do you want to install Intercept? (y/n)" 
if ($answer -ne "y") {
  return
}
# Get Temporary Directory
$TempDir = [System.IO.Path]::GetTempPath()
# Download Intercept to Temporary Directory
Invoke-WebRequest -Uri "https://github.com/oblitum/Interception/releases/download/v1.0.1/Interception.zip" -OutFile "$TempDir\intercept.zip"
Expand-Archive -Path "$TempDir\intercept.zip" -DestinationPath "$TempDir\intercept" -Force
# Run Intercept install in "DestinationPath\Interception\command line installer\install-interception.exe /install"
Start-Process -FilePath "$TempDir\intercept\Interception\command line installer\install-interception.exe" -ArgumentList "/install" -Wait
Write-Host "Intercept Installed" -ForegroundColor Green
Write-Host ""

# Install AHK (selection v1 or v2)
$AHKDownloadURL = ""
$AHKVer = ""
$answer = Read-Host "Pick AutoHotkey version? (1/2/n)"
if ($answer -eq "n") { return }
if ($answer -eq "1") {
  $AHKDownloadURL = "https://www.autohotkey.com/download/ahk-v2.exe"
  $AHKVer = "1"
}
if ($answer -eq "2") {
  $AHKDownloadURL = "https://www.autohotkey.com/download/ahk-install.exe"
  $AHKVer = "2"
}

Write-Host "Installing AutoHotkey..." -ForegroundColor Green
Write-Host ""
Invoke-WebRequest -Uri $AHKDownloadURL -OutFile "$TempDir\ahk.exe"
Start-Process -FilePath "$TempDir\ahk.exe" -ArgumentList "/silent" -Wait
Write-Host "AutoHotkey Installed" -ForegroundColor Green
Write-Host ""

# Create AutoHotkey folder if it doesn't exist
if (!(Test-Path -Path "$env:USERPROFILE\Documents\AutoHotkey")) {
  New-Item -Path "$env:USERPROFILE\Documents\AutoHotkey" -ItemType Directory
}

# Download AutoHotIntercepton
Write-Host "Downloading AutoHotIntercepton..." -ForegroundColor Green
if ($AHKVer -eq "1") {
  Invoke-WebRequest -Uri "https://github.com/evilC/AutoHotInterception/releases/download/v0.5.2/AutoHotInterception.zip" -OutFile "$TempDir\AutoHotIntercepton.zip"
}
if ($AHKVer -eq "2") {
  Invoke-WebRequest -Uri "https://github.com/evilC/AutoHotInterception/releases/download/v0.9.1/AutoHotInterception.zip" -OutFile "$TempDir\AutoHotIntercepton.zip"
}
Expand-Archive -Path "$TempDir\AutoHotIntercepton.zip" -DestinationPath "$TempDir\AutoHotIntercepton" -Force

if ($AHKVer -eq "1") {
  # Copy AutoHotIntercepton\Lib\ to Documents\AutoHotkey
  Copy-Item -Path "$TempDir\AutoHotIntercepton\Lib" -Destination "$env:USERPROFILE\Documents\AutoHotkey" -Recurse -Force
  # Copy AutoHotIntercepton\Monitor.ahk to Documents\AutoHotkey
  Copy-Item -Path "$TempDir\AutoHotIntercepton\Monitor.ahk" -Destination "$env:USERPROFILE\Documents\AutoHotkey" -Force
}
if ($AHKVer -eq "2") {
  # Copy AutoHotInterception\AHK v2\lib\ to Documents\AutoHotkey
  Copy-Item -Path "$TempDir\AutoHotIntercepton\AHK v2\lib" -Destination "$env:USERPROFILE\Documents\AutoHotkey" -Recurse -Force
  # Copy AutoHotInterception\AHK v2\AutoHotInterception.dll to Documents\AutoHotkey\lib
  Copy-Item -Path "$TempDir\AutoHotIntercepton\AHK v2\AutoHotInterception.dll" -Destination "$env:USERPROFILE\Documents\AutoHotkey\lib" -Force
  # Copy AutoHotInterception\AHK v2\Monitor.ahk to Documents\AutoHotkey
  Copy-Item -Path "$TempDir\AutoHotIntercepton\AHK v2\Monitor.ahk" -Destination "$env:USERPROFILE\Documents\AutoHotkey" -Force
}
# Copy Interception\librarys\x64\ and x86\ to Documents\AutoHotkey\Lib
Copy-Item -Path "$TempDir\intercept\Interception\library\x64" -Destination "$env:USERPROFILE\Documents\AutoHotkey\Lib" -Recurse -Force
Copy-Item -Path "$TempDir\intercept\Interception\library\x86" -Destination "$env:USERPROFILE\Documents\AutoHotkey\Lib" -Recurse -Force
# go to Documents\AutoHotkey\Lib and run unblocker
Get-ChildItem -Path "$env:USERPROFILE\Documents\AutoHotkey\Lib" -Recurse | Unblock-File
Write-Host "AutoHotIntercepton Installed" -ForegroundColor Green
Write-Host ""
$tapHold = "0"
$answer = Read-Host "Continue installing TapHoldManager (y/n)"
if ($answer -eq "y") {
  $tapHold = "1"
  # Download TapHoldManager
  Write-Host "Downloading TapHoldManager..." -ForegroundColor Green
  Invoke-WebRequest -Uri "https://github.com/evilC/TapHoldManager/releases/download/v2.0/TapHoldManager.zip" -OutFile "$TempDir\TapHoldManager.zip"
  Expand-Archive -Path "$TempDir\TapHoldManager.zip" -DestinationPath "$TempDir\TapHoldManager" -Force
  if ($AHKVer -eq "1") {
    # Copy TapHoldManager\AHK v1\lib\ to Documents\AutoHotkey\
    Copy-Item -Path "$TempDir\TapHoldManager\AHK v1\lib" -Destination "$env:USERPROFILE\Documents\AutoHotkey" -Recurse -Force
  } 
  if ($AHKVer -eq "2") {
    # Copy TapHoldManager\AHK v2\lib\ to Documents\AutoHotkey\
    Copy-Item -Path "$TempDir\TapHoldManager\AHK v2\lib" -Destination "$env:USERPROFILE\Documents\AutoHotkey" -Recurse -Force
  }
  
  Write-Host "TapHoldManager Installed" -ForegroundColor Green
}

# Clean up
Remove-Item -Path "$TempDir\AutoHotIntercepton.zip" -Force
Remove-Item -Path "$TempDir\AutoHotIntercepton" -Recurse -Force
Remove-Item -Path "$TempDir\intercept.zip" -Force
Remove-Item -Path "$TempDir\intercept" -Recurse -Force
Remove-Item -Path "$TempDir\TapHoldManager.zip" -Force
Remove-Item -Path "$TempDir\TapHoldManager" -Recurse -Force

# Create example
Write-Host "Creating example..." -ForegroundColor Green
$createAHK = ""
if ($AHKVer -eq "1") {
  # Check tapHold
  if ($tapHold -eq "1") {
    # Write a file
    $createAHK = @"
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#SingleInstance force
#Persistent

#include <AutoHotInterception>
#include <TapHoldManager> 
#include <InterceptionTapHold>

AHI := new AutoHotInterception()

debug := 0

keyboardId := AHI.GetKeyboardId(0x1A2C, 0x0B2A) ;Paste 2nd keyboard here
ITH1 := new InterceptionTapHold(AHI, keyboardId)

AHI.SubscribeKeyboard(keyboardId, true, Func("KeyEvent"))

ITH1.Add("Space", Func("Example"), , 200)

return

Example(isHold, taps, state) {

    if (isHold = 1) & (taps = 1) & (state) {
      Send, "Welcome TapHoldManager"
    }

}


KeyEvent(code, state) {

    if (state) & (code = 30) {
      Send, "Hello, AHI"
    }


  global debug

  If (debug = 1) & (state) {
    Clipboard := code
    ToolTip %"Keyboard Key - Code: " code ", State: " state
    Sleep, 6000
    ToolTip
  }

}

^Esc:: ExitApp
^!p:: Pause ; Pause script with Ctrl+Alt+P
^!s:: Suspend ; Suspend script with Ctrl+Alt+S
^!r:: Reload ; Reload script with Ctrl+Alt+R
^!q::
if (debug = 0)
  debug := 1
else
  debug := 0
ToolTip %"Debug " debug
Sleep, 2000
ToolTip
Return
"@
  }
  else {
    # Write a file
    $createAHK = @"
    #NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#SingleInstance force
#Persistent

#include <AutoHotInterception>

AHI := new AutoHotInterception()

debug := 0

keyboardId := AHI.GetKeyboardId(0x1A2C, 0x0B2A) ;Paste 2nd keyboard here
AHI.SubscribeKeyboard(keyboardId, true, Func("KeyEvent"))


return

KeyEvent(code, state) {

    if (state) & (code = 30) {
      Send, "Hello, AHI"
    }


  global debug

  If (debug = 1) & (state) {
    Clipboard := code
    ToolTip %"Keyboard Key - Code: " code ", State: " state
    Sleep, 6000
    ToolTip
  }

}

^Esc:: ExitApp
^!p:: Pause ; Pause script with Ctrl+Alt+P
^!s:: Suspend ; Suspend script with Ctrl+Alt+S
^!r:: Reload ; Reload script with Ctrl+Alt+R
^!q::
if (debug = 0)
  debug := 1
else
  debug := 0
ToolTip %"Debug " debug
Sleep, 2000
ToolTip
Return
"@
  }
}
if ($AHKVer -eq "2") {
  if ($tapHold -eq "1") {
    # Write a file
    $createAHK = @"
; REMOVED: #NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.

#SingleInstance force
Persistent

#Include "<AutoHotInterception>"
#Include "<TapHoldManager>"
#Include "<InterceptionTapHold>"

AHI := AutoHotInterception()

debug := 0

keyboardId := AHI.GetKeyboardId(0x1A2C, 0x0B2A) ;Paste 2nd keyboard here
ITH1 := InterceptionTapHold(AHI, keyboardId)

AHI.SubscribeKeyboard(keyboardId, true, KeyEvent)

ITH1.Add("Space", Example, , 200)

return

Example(isHold, taps, state) {

  if (isHold = 1) & (taps = 1) & (state) {
    Send("Welcome TapHoldManager")
  }

}


KeyEvent(code, state) {

  if (state) & (code = 30) {
    Send("Hello, AHI!")
  }


  global debug

  If (debug = 1) & (state) {
    A_Clipboard := code
    ToolTip("Keyboard Key - Code: " code ", State: " state)
    SetTimer () => ToolTip(), -6000
  }

}

^Esc:: ExitApp()
^!p:: Pause() ; Pause script with Ctrl+Alt+P
^!s:: Suspend() ; Suspend script with Ctrl+Alt+S
^!r:: Reload() ; Reload script with Ctrl+Alt+R
^!q::
{ ; V1toV2: Added bracket
  global ; V1toV2: Made function global
  if (debug = 0)
    debug := 1
  else
    debug := 0
  ToolTip("Debug " debug)
  Sleep(2000)
  ToolTip()
  Return
} ; V1toV2: Added bracket in the end

"@
  }
  else {
    # Write a file
    $createAHK = @"
#Requires AutoHotkey v2.0
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.

#SingleInstance force
Persistent

#Include "<AutoHotInterception>"

AHI := AutoHotInterception()

debug := 0

keyboardId := AHI.GetKeyboardId(0x1A2C, 0x0B2A) ;Paste 2nd keyboard here
AHI.SubscribeKeyboard(keyboardId, true, KeyEvent)

return

KeyEvent(code, state) {

  if (state) & (code = 30) {
    Send("Hello, AHI!")
  }


  global debug

  If (debug = 1) & (state) {
    A_Clipboard := code
    ToolTip("Keyboard Key - Code: " code ", State: " state)
    SetTimer () => ToolTip(), -6000
  }

}

^Esc:: ExitApp()
^!p:: Pause() ; Pause script with Ctrl+Alt+P
^!s:: Suspend() ; Suspend script with Ctrl+Alt+S
^!r:: Reload() ; Reload script with Ctrl+Alt+R
^!q::
{
  global
  if (debug = 0)
    debug := 1
  else
    debug := 0
  ToolTip("Debug " debug)
  Sleep(2000)
  ToolTip()
  Return
}
"@
  }
}
# Save as Example.ahk
$createAHK | Out-File "$env:USERPROFILE\Documents\AutoHotkey\Example.ahk"
Write-Host "Change your keyboard id" -ForegroundColor Green
Write-Host "keyboardId := AHI.GetKeyboardId(0x1A2C, 0x0B2A) <- this" -ForegroundColor Blue
Write-Host ""
Write-Host "Restart your computer!" -ForegroundColor Green
