# . "C:\Users\amirhosseindotzip\.config\powershell\mpv-powershell-completion.ps1"
# Set-Alias v nvim
Set-Alias grep "C:\Program Files\Git\usr\bin\grep.exe"
# Set-Alias awk "C:\Program Files\Git\usr\bin\awk.exe"
# Set-Alias tig "C:\Program Files\Git\usr\bin\tig.exe"
# Set-Alias less "C:\Program Files\Git\usr\bin\less.exe"
Set-Alias mkdir "C:\Program Files\Git\usr\bin\mkdir.exe"
Set-Alias touch "C:\Program Files\Git\usr\bin\touch.exe"
# Set-Alias find "C:\Program Files\Git\usr\bin\find.exe"
Set-Alias mv "C:\Program Files\Git\usr\bin\mv.exe"
Set-Alias tail "C:\Program Files\Git\usr\bin\tail.exe"
Set-Alias cmatrix "C:\Users\amirhosseindotzip\.config\powershell\cmatrix.ps1"
Set-Alias pr "C:\Users\amirhosseindotzip\.config\powershell\pr.ps1"
Set-Alias Clock "C:\Users\amirhosseindotzip\.config\powershell\clock.ps1"
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

function prompt {
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $IsAdmin = ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    $pathDisplay = " 📂 $pwd "
    $LastCommand = Get-History -Count 1
    if ($LastCommand) {
        $RunTime = [math]::Round(($LastCommand.EndExecutionTime - $LastCommand.StartExecutionTime).TotalSeconds)
        $ElapsedTime = "$RunTime s"
    }
    else {
        $ElapsedTime = "0 sec"
    }
    if ($IsAdmin) {
        Write-Host " 👑 " -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    }
    Write-Host " 👤 $env:USERNAME " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
    Write-Host $pathDisplay -ForegroundColor White -BackgroundColor DarkGray -NoNewline
    Write-Host " ⌚️$ElapsedTime " -ForegroundColor White -BackgroundColor DarkGray
    return " 🤖  "
}

# Module Imports
Import-Module PSFzf
Import-Module Terminal-Icons

function asdf {ping asdf.com}

# copy /b pic.jpg+tel.zip pix.jpg

function anonsurf {
    # Change to the specified directory
    Set-Location "D:\Dev\python\AnonSurf"
    & "D:\Dev\python\AnonSurf\env\Scripts\python.exe" "D:\Dev\python\AnonSurf\AnonSurf.py" start
    # Start-Process -FilePath "D:\Dev\python\AnonSurf\env\Scripts\python.exe" -ArgumentList "D:\Dev\python\AnonSurf\AnonSurf.py start" -NoNewWindow -Wait
}

function winutil {irm "https://christitus.com/win" | iex}
${function:~} = { Set-Location ~ }

${function:v2ray} = {
    set-location "C:\Users\amirhosseindotzip\Desktop"
    $urls = @(
        "https://raw.githubusercontent.com/youfoundamin/V2rayCollector/main/vmess_iran.txt",
        "https://raw.githubusercontent.com/youfoundamin/V2rayCollector/main/ss_iran.txt",
        "https://raw.githubusercontent.com/youfoundamin/V2rayCollector/main/trojan_iran.txt",
        "https://raw.githubusercontent.com/youfoundamin/V2rayCollector/main/vless_iran.txt",
        "https://raw.githubusercontent.com/youfoundamin/V2rayCollector/main/mixed_iran.txt"
    )
    foreach ($url in $urls) {
        $fileName = [System.IO.Path]::GetFileName($url)
        # & wget $url
        Invoke-WebRequest -Uri $url -OutFile $fileName
    }
}

# restart the windows explorer
Function rx {
    taskkill /im explorer.exe /f
    start explorer.exe
    exit
}

Function setprox {
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$ProxyServer,

        [Parameter(Position = 1, Mandatory = $true)]
        [int]$ProxyPort
    )

    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $proxyValue = $ProxyServer + ":" + $ProxyPort
    Set-ItemProperty -Path $regPath -Name ProxyServer -Value $proxyValue
    Set-ItemProperty -Path $regPath -Name ProxyEnable -Value 1
    Write-Output "Proxy server enabled successfully!"
}

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

function mmm {
    Set-Location D:\Music
    $query = fzf --prompt=" 🎧 Search for Infinity    " --height=70% --layout=reverse --border --exit-0
    mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle $query
    mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle "D:\Music"
}
function psc {
    Set-Location D:\Dev\powershell\PowerShell-fleschutz\scripts
    $query = fzf --prompt=" 🎧 Search for Infinity    " --height=70% --layout=reverse --border --exit-0
    $query
    & .\$query
}
function vvv {
    $drives = "D:\", "C:\"
    $getDrive = $drives | fzf --prompt="select drive to search... " --height=20% --layout=reverse --border --exit-0
    Set-Location $getDrive
    $query = fzf --prompt=" 🎧 Search for Infinity    " --height=70% --layout=reverse --border --exit-0
    explorer.exe $query &
}
function spc {
    $allCommands = Get-Command
    $query = $allCommands | fzf --prompt="select drive to search... " --height=90% --layout=reverse --border --exit-0
}

function ShowWifiPasswords { (netsh wlan show profiles) | Select-String "\:(.+)$" | % { $name = $_.Matches.Groups[1].Value.Trim(); $_ } | % { (netsh wlan show profile name="$name" key=clear) }  | Select-String "Key Content\W+\:(.+)$" | % { $pass = $_.Matches.Groups[1].Value.Trim(); $_ } | % { [PSCustomObject]@{ PROFILE_NAME = $name; PASSWORD = $pass } } | Format-Table -AutoSize }
function perplexity { powershell D:\Programs\vivaldi\Application\vivaldi.exe --app=https://www.perplexity.ai; exit; }
function p8 { ping 8.8.8.8 -t }
function bat { param($a) & "C:\Users\amirhosseindotzip\scoop\apps\bat\0.24.0\bat.exe" $a }
function whenexpire { slmgr /xpr }
function getName { wmic "csproduct get name" }
# function schrome { chrome.exe --user-data-dir="C:/Chrome dev session" --disable-web-security }
# function cc { & "C:\Program Files\Mozilla Firefox\firefox.exe" -private-window 'https://chatbot.theb.ai'; exit }
function fcs    { curl "https://wttr.in/tonekabon" }
function fcs2 { curl "https://v2.wttr.in/tonekabon" }
function des { Set-Location "C:\Users\amirhosseindotzip\Desktop\" }
function which($command) { Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }
function psconf {
    Set-Location C:\Users\amirhosseindotzip\.config\powershell;
    astronvim "C:\Users\amirhosseindotzip\.config\powershell\user_profile.ps1" 
}
function psv {
    Set-Location C:\Users\amirhosseindotzip\.config\powershell;
    nvim "C:\Users\amirhosseindotzip\.config\powershell\user_profile.ps1" 
}
function psfold { Set-Location "C:\Users\amirhosseindotzip\.config\powershell" }
function hist { nvim "C:\Users\amirhosseindotzip\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
function histc { code "C:\Users\amirhosseindotzip\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
function yymp3 ($link) { yt-dlp -x --audio-format mp3 --output '%(title)s.%(ext)s' $link }

function ytplaylist ($link, $quality = 1080) {
    $format = "(bestvideo[height<=$quality]+bestaudio/best[height<=$quality])"
    yt-dlp -f $format -o "%(playlist_index)s - %(title)s.%(ext)s" $link
}

function yy ($url) { yt-dlp -f "best[height<=720]" $url }
function fuck { Write-Output "Fuck Yeah"; }
Function x { explorer.exe . }
Function rc { Start-Process shell:RecycleBinFolder; exit; }
function sysinfo { powershell gwmi win32_bios }
Function m { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle $args }
Function mm { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle "D:\Music" }
function cm { Set-Location D:\Music }
function D { Set-Location "D:\" }
function ShowWifiPasswords { (netsh wlan show profiles) | Select-String "\:(.+)$" | % { $name = $_.Matches.Groups[1].Value.Trim(); $_ } | % { (netsh wlan show profile name="$name" key=clear) }  | Select-String "Key Content\W+\:(.+)$" | % { $pass = $_.Matches.Groups[1].Value.Trim(); $_ } | % { [PSCustomObject]@{ PROFILE_NAME = $name; PASSWORD = $pass } } | Format-Table -AutoSize }

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
    }
    else {
        $filePath = $Path
    }
    try {
        # Invoke-WebRequest -Uri "https://transfer.sh/$fileName" -Method Put -InFile $filePath |
        Invoke-WebRequest -Uri "https://transfer.whalebone.io/$fileName" -Method Put -InFile $filePath |

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

# function v() {
#     $env:NVIM_APPNAME = "nvim"
#     nvim $args
# }

function nvims() {
    $items = "default", "LazyNvim", "AstroNvim", "NvChad", "EmptyNvim", "lazynvim", "jnvim"
    $config = $items | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0

    if ([string]::IsNullOrEmpty($config)) {
        Write-Output "Nothing selected"
        break
    }
 
    if ($config -eq "default") {
        $config = ""
    }

    $env:NVIM_APPNAME = $config
    nvim $args
}

function findkill {
    $selectedProcess = Get-Process | ForEach-Object { "$($_.Id): $($_.ProcessName)" } | fzf | ForEach-Object { $_.Split(':')[0] }
    if ($selectedProcess) {
        Stop-Process -Id $selectedProcess
    }
}
function fdir {
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
        [string]$Editor = "nvim"
    )

    $selectedFile = Get-ChildItem -LiteralPath $Path -File -Recurse | Select-Object -ExpandProperty FullName | fzf

    if ($selectedFile) {
        & $Editor $selectedFile
    }
}

# Invoke-Expression (&starship init powershell)
# (ptr completion) -join "`n" | iex
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })