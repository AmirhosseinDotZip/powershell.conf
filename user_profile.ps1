# Set-Alias v nvim
Set-Alias ll ls
Set-Alias grep findstr
Set-Alias tig "C:\Program Files\Git\usr\bin\tig.exe"
Set-Alias less "C:\Program Files\Git\usr\bin\less.exe"
Set-Alias mkdir "C:\Program Files\Git\usr\bin\mkdir.exe"
Set-Alias touch "C:\Program Files\Git\usr\bin\touch.exe"
Set-Alias mv "C:\Program Files\Git\usr\bin\mv.exe"
Set-Alias tail "C:\Program Files\Git\usr\bin\tail.exe"
Set-Alias cpy "C:\Program Files\Git\usr\bin\cp.exe"
Set-Alias bat "C:\Program Files\Git\usr\bin\bat.exe"
Set-Alias cmatrix "C:\Users\baniminator\.config\powershell\cmatrix.ps1"
Set-Alias pray "C:\Users\baniminator\.config\powershell\pr.ps1"

${function:~} = { Set-Location ~ }
 
# Directory Listing: Use `ls.exe` if available
if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path)
{
    rm alias:ls -ErrorAction SilentlyContinue
# Set `ls` to call `ls.exe` and always use --color
        ${function:ls} = { ls.exe --color @args }
# List all files in long format
    ${function:l} = { ls -lF @args }
# List all files in long format, including hidden files
    ${function:la} = { ls -laF @args }
# List only directories
    ${function:ld} = { Get-ChildItem -Directory -Force @args }
} else
{
# List all files, including hidden files
    ${function:la} = { ls -Force @args }
# List only directories
    ${function:ld} = { Get-ChildItem -Directory -Force @args }
}


Function setprox {
    Param (
        [Parameter(Position=0, Mandatory=$true)]
        [string]$ProxyServer,

        [Parameter(Position=1, Mandatory=$true)]
        [int]$ProxyPort
    )

    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $proxyValue = $ProxyServer + ":" + $ProxyPort
    Set-ItemProperty -Path $regPath -Name ProxyServer -Value $proxyValue
    Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1
    Write-Output "Proxy server enabled successfully!"}

Function prox {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1
    Write-Output "Proxy server enabled successfully!"
}

Function noprox {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 0
    Write-Output "Proxy server disabled successfully!"
}

function getName {wmic "csproduct get name"}
function schrome {chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security}
function cc { & "C:\Program Files\Mozilla Firefox\firefox.exe" -private-window 'https://chatbot.theb.ai';exit }
function fcs { curl "https://wttr.in/tonekabon" }
function fcs2 { curl "https://v2.wttr.in/tonekabon" }
function des { Set-Location "C:\Users\baniminator\Desktop\" }
function which($command) { Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }
function psconf { astronvim "C:\Users\baniminator\.config\powershell\user_profile.ps1" }
function psfold { Set-Location "C:\Users\baniminator\.config\powershell" }
function nvconf { nvim "C:\Users\baniminator\AppData\Local\nvim\init.lua" }
function nvfold { Set-Location C:\Users\baniminator\AppData\Local\nvim }
function nxfold { Set-Location D:\sourceerror\Web\frontend\._NEXT\}
function hist { v "C:\Users\baniminator\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
# {yt-dlp -x --audio-format mp3 --output '%(playlist_index)s-%(title)s.%(ext)s' $link
function yymp3 ($link) { yt-dlp -x --audio-format mp3 --output '%(title)s.%(ext)s' $link }
function yy ($url) { yt-dlp -f "best[height<=720]" $url }
function sourceerror { Set-Location "D:\sourceerror" }
function fuck { Write-Output "Fuck Yeah"; }
Function ex { explorer.exe . }
Function rc { Start-Process shell:RecycleBinFolder; exit; }
Function m { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle $args }
Function mplay { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback $args }
Function mm { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle "D:\Music" }
function cdm { Set-Location D:\Music }
function d {Set-Location "D:\"}


function prompt {
    $host.ui.RawUI.WindowTitle = "$pwd"
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $Date = Get-Date -Format 'dddd hh:mm:ss tt'
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    $LastCommand = Get-History -Count 1
    if ($lastCommand) {
        $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds 
    }
    if ($RunTime -ge 60) {
        $ts = [timespan]::fromseconds($RunTime)
        $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
        $ElapsedTime = -join ($min, " min ", $sec, " sec")
    }
    else {
        $ElapsedTime = [math]::Round(($RunTime), 2)
        $ElapsedTime = -join (($ElapsedTime.ToString()), " sec")
    }
    Write-Host ""
    Write-host ($(if ($IsAdmin) {
                'Elevated ' 
            }
            else {
                '' 
            })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host " USER:$($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor Blue -ForegroundColor White -NoNewline
    If ($CmdPromptCurrentFolder -like "*:*") {
        Write-Host " $CmdPromptCurrentFolder "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    }
    else {
        Write-Host ".\$CmdPromptCurrentFolder\ "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    }
    Write-Host " $date " -ForegroundColor White -BackgroundColor Blue -NoNewLine
    Write-Host "⌚️$elapsedTime " -ForegroundColor White -BackgroundColor DarkGray 
    return "🚀🚀🚀 "
} 


function transfer {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias("FullName")]
        [String]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Host "$($Path): No such file or directory" -ErrorAction Stop
    }

    $fileName = (Split-Path $Path -Leaf).Replace(' ', '_')

    if ((Test-Path $Path) -and (Get-Item $Path).PSIsContainer) {
        $zipPath = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName() + '.zip')
        Compress-Archive -Path $Path -DestinationPath $zipPath -Quiet
        $filePath = $zipPath
    } else {
        $filePath = $Path
    }

    try {
        Invoke-WebRequest -Uri "https://transfer.sh/$fileName" -Method Put -InFile $filePath |
            Select-Object -ExpandProperty Content
    }
    catch {
        Write-Host "An error occurred while uploading the file."
        Write-Host $_.Exception.Message
    }
    finally {
        if ($zipPath) {
            Remove-Item -Path $zipPath -ErrorAction SilentlyContinue
        }
    }
}



# process info function


# Revised function to get process information
function pinfo {
  param(
    [Parameter(Position=0)]
    [alias("pn")]
    [string]$ProcessName,
    
    [Parameter(Position=1)]
    [alias("pid")]
    [int]$ProcessId
  )

  begin {
    $procs = @() 
  }

  process {

    if ($ProcessName) {
    
      $procs += Get-Process | Where-Object { $_.Name -match $ProcessName }
    
    }
    elseif ($ProcessId) {

      $procs += Get-Process -Id $ProcessId -ErrorAction SilentlyContinue

    }
    else {
    
      $procs += Get-Process
    
    }

  }

  end {

    if (-not $procs) {
      Write-Warning "No matching processes found"
      return
    }

    foreach ($proc in $procs) {

      Write-Host "Process Name: $($proc.Name)" -ForegroundColor Cyan
      
      try {
        $path = (Get-Process -Id $proc.Id -ErrorAction Stop).Path
      }
      catch {
        $path = $null 
      }

      if ($path) {
        Write-Host "Process Path: $path" -ForegroundColor Green  
      }

      try {
        $cmdline = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)" -ErrorAction Stop).CommandLine
        Write-Host "Command Line: $cmdline" -ForegroundColor Green 
      }
      catch {
        Write-Warning "Unable to get command line"
      }
    }
  }
}

# New function to check which process is using a specific port
function portinfo {
  param(
    [Parameter(Position=0, Mandatory=$true)]
    [alias("p")]
    [int]$Port
  )

  $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue

  if ($connections) {
    foreach ($conn in $connections) {
      try {
        $proc = Get-Process -Id $conn.OwningProcess -ErrorAction Stop
        $procName = $proc.Name
        $procPath = $proc.Path
      }
      catch {
        $procName = $null
        $procPath = $null
      }

      Write-Host "Port $Port is being used by process $procName (ID: $($conn.OwningProcess))" -ForegroundColor Red
      if ($procPath) {
        Write-Host "Process Path: $procPath" -ForegroundColor Green  
      }
    }
  }
  else {
    Write-Host "Port $Port is not in use" -ForegroundColor Green
  }
}

#_________________________________________________________________________
#_________________________________________________________________________
#_________________________________________________________________________
#_________________________________________________________________________
#_________________________________________________________________________
#_________________________________________________________________________


function lazynvim()
{
  $env:NVIM_APPNAME="lazynvim"
  nvim $args
}
function nvchad()
{
  $env:NVIM_APPNAME="NvChad"
  nvim $args
}
function astronvim()
{
  $env:NVIM_APPNAME="AstroNvim"
  nvim $args
}
function v()
{
  $env:NVIM_APPNAME="AstroNvim"
  nvim $args
}
function jnvim()
{
  $env:NVIM_APPNAME="jnvim"
  nvim $args
}
function nvims()
{
  $items = "default", "LazyNvim", "AstroNvim", "NvChad", "EmptyNvim", "lazynvim", "jnvim"
  $config = $items | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0

  if ([string]::IsNullOrEmpty($config))
  {
    Write-Output "Nothing selected"
    break
  }
 
  if ($config -eq "default")
  {
    $config = ""
  }

  $env:NVIM_APPNAME=$config
  nvim $args
}



function findkill {
    $selectedProcess = Get-Process | ForEach-Object { "$($_.Id): $($_.ProcessName)" } | fzf | ForEach-Object { $_.Split(':')[0] }
    if ($selectedProcess) {
        Stop-Process -Id $selectedProcess
    }
}
function fdir{
    param (
        [string]$Path = $PWD.Path
    )

    $selectedPath = Get-ChildItem -LiteralPath $Path -Directory -Recurse | Select-Object -ExpandProperty FullName | fzf

    if ($selectedPath) {
        Set-Location -LiteralPath $selectedPath
    }
}

function ffile {
    param (
        [string]$Path = $PWD.Path,
        [string]$Editor = "astronvim"
    )

    $selectedFile = Get-ChildItem -LiteralPath $Path -File -Recurse | Select-Object -ExpandProperty FullName | fzf

    if ($selectedFile) {
        & $Editor $selectedFile
    }
}


function cfile {
    param (
        [string]$Path = $PWD.Path
    )

    $selectedFile = Get-ChildItem -LiteralPath $Path -File -Recurse | Select-Object -ExpandProperty FullName | fzf

    if ($selectedFile) {
        $editorList = @( "astronvim", "code", "vim", "nvim", "notepad", "qview", "mpv", "firefox", "chrome")
        $selectedEditor = $editorList | fzf

        if ($selectedEditor) {
            & $selectedEditor $selectedFile
        }
    }
}


function ws {
    param(
        [string]$foldername
    )
    $webstormPath = "C:\Program Files\JetBrains\WebStorm 2022.2\bin\webstorm64.exe"
    $arguments = $foldername
    if (Test-Path $webstormPath) {
        Start-Process $webstormPath -ArgumentList $arguments -WindowStyle Hidden
    } else {
        Write-Host "WebStorm not found at path: $webstormPath"
    }
}



# mpv videoName -sub-file sub1 -sub-file sub2 -secondary-sid 2





# Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
