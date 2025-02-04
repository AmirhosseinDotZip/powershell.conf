# . "C:\Users\amirhosseindotzip\.config\powershell\mpv-powershell-completion.ps1"
# Set-Alias v nvim
Set-Alias ll ls
# Set-Alias grep findstr
Set-Alias c "C:\Users\amirhosseindotzip\AppData\Local\Programs\Microsoft VS Code\Code.exe"
Set-Alias grep "C:\Program Files\Git\usr\bin\grep.exe"
Set-Alias awk "C:\Program Files\Git\usr\bin\awk.exe"
Set-Alias tig "C:\Program Files\Git\usr\bin\tig.exe"
Set-Alias less "C:\Program Files\Git\usr\bin\less.exe"
Set-Alias mkdir "C:\Program Files\Git\usr\bin\mkdir.exe"
Set-Alias touch "C:\Program Files\Git\usr\bin\touch.exe"
Set-Alias find "C:\Program Files\Git\usr\bin\find.exe"
Set-Alias mv "C:\Program Files\Git\usr\bin\mv.exe"
Set-Alias tail "C:\Program Files\Git\usr\bin\tail.exe"
Set-Alias cpy "C:\Program Files\Git\usr\bin\cp.exe"
Set-Alias bat "C:\Program Files\Git\usr\bin\bat.exe"
Set-Alias cmatrix "C:\Users\amirhosseindotzip\.config\powershell\cmatrix.ps1"
Set-Alias pray "C:\Users\amirhosseindotzip\.config\powershell\pr.ps1"
Set-Alias fkill Invoke-FuzzyKillProcess
Set-Alias fcd Invoke-FuzzySetLocation
Set-Alias fscoop Invoke-FuzzyScoop
Set-Alias digitalClock "C:\Users\amirhosseindotzip\.config\powershell\clock.ps1"
Set-Alias ytdlp "C:\Users\amirhosseindotzip\.config\powershell\ytdlp.ps1"



# Set-Alias -Name cd -Value z -Option AllScope

# The Main Prompt
function prompt {
    # Environment Setup
    # $host.ui.RawUI.WindowTitle = "$pwd"
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    # $Date = Get-Date -Format 'dddd hh:mm:ss tt'
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    # Color Theme
    $colors = @{
        AdminBg     = "DarkRed"
        AdminFg     = "White"
        UserBg      = "DarkBlue"
        UserFg      = "White"
        PathBg      = "DarkGray"
        PathFg      = "White"
        GitBg       = "Blue"           # Changed from DarkMagenta to Blue
        GitFg       = "White"
        TimeBg      = "DarkCyan"
        TimeFg      = "White"
        BatteryBg   = "Green"      # Changed from DarkYellow to Green
        BatteryFg   = "Black"      # Changed to Black for better contrast on Green
        PythonBg    = "DarkGreen"
        PythonFg    = "White"
        ExecutionBg = "DarkGray"
        ExecutionFg = "White"
    }

    # function Get-BatteryStatus {
    #     $battery = Get-CimInstance Win32_Battery
    #     if ($battery) {
    #         $percentage = $battery.EstimatedChargeRemaining
    #         $status = if ($battery.BatteryStatus -eq 2) { "⚡" } else { "🔋" }
    #         return "$status$percentage%"
    #     }
    #     return $null
    # }

    # Git Status Function with Extended Information
         function Get-GitStatus {
         if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
             return $null
         }

         # Check if current directory is inside a git repository
         if (-not (git rev-parse --is-inside-work-tree -ErrorAction SilentlyContinue)) {
             return $null
         }

         # Proceed with existing git status retrieval
         try {
             $branch = git rev-parse --abbrev-ref HEAD 2>$null
             if ($branch) {
                 $status = git status --porcelain
                 $ahead = git status -sb 2>$null | Select-String "\[ahead (\d+)\]" | ForEach-Object { $_.Matches.Groups[1].Value }
                 $behind = git status -sb 2>$null | Select-String "\[behind (\d+)\]" | ForEach-Object { $_.Matches.Groups[1].Value }

                 $stashCount = (git stash list | Measure-Object -Line).Lines
                 $untracked = (git ls-files --others --exclude-standard | Measure-Object -Line).Lines

                 $gitInfo = " $branch"
                 if ($status) { $gitInfo += " ●" }
                 if ($ahead) { $gitInfo += " ↑$ahead" }
                 if ($behind) { $gitInfo += " ↓$behind" }
                 if ($stashCount -gt 0) { $gitInfo += " 📦$stashCount" }
                 if ($untracked -gt 0) { $gitInfo += " ?$untracked" }

                 return $gitInfo
             }
         }
         catch {
             return $null
         }

         return $null
     }
     

    # Python Virtual Environment Detection
    function Get-VirtualEnvInfo {
        if ($env:VIRTUAL_ENV) {
            return " 🐍 $(Split-Path $env:VIRTUAL_ENV -Leaf)"
        }
        return $null
    }

    # Command Execution Time
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

    # Display Prompt
    Write-Host ""
    
    # Admin Status
    if ($IsAdmin) {
        Write-Host " 👑 Admin " -BackgroundColor $colors.AdminBg -ForegroundColor $colors.AdminFg -NoNewline
    }

    # User and Path
    Write-Host " 👤 $($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor $colors.UserBg -ForegroundColor $colors.UserFg -NoNewline
    
    # Path with different style for drives
    If ($CmdPromptCurrentFolder -like "*:*") {
        Write-Host " 📂 $CmdPromptCurrentFolder " -ForegroundColor $colors.PathFg -BackgroundColor $colors.PathBg -NoNewline
    }
    else {
        Write-Host " 📂 .\$CmdPromptCurrentFolder\ " -ForegroundColor $colors.PathFg -BackgroundColor $colors.PathBg -NoNewline
    }

    # Battery Status
    # $batteryStatus = Get-BatteryStatus
    # if ($batteryStatus) {
    #     Write-Host " $batteryStatus " -ForegroundColor $colors.BatteryFg -BackgroundColor $colors.BatteryBg -NoNewline
    # }

    # Git Status
    $gitStatus = Get-GitStatus
    if ($gitStatus) {
        Write-Host " $gitStatus " -ForegroundColor $colors.GitFg -BackgroundColor $colors.GitBg -NoNewline
    }

    # Python Virtual Environment
    $venvInfo = Get-VirtualEnvInfo
    if ($venvInfo) {
        Write-Host $venvInfo -ForegroundColor $colors.PythonFg -BackgroundColor $colors.PythonBg -NoNewline
    }

    # Time and Execution Duration
    # Write-Host " $date " -ForegroundColor $colors.TimeFg -BackgroundColor $colors.TimeBg -NoNewLine
    Write-Host " ⌚️$elapsedTime " -ForegroundColor $colors.ExecutionFg -BackgroundColor $colors.ExecutionBg 

    # return "λ "
    return " 🤖  "
}

# Module Imports
Import-Module PSFzf
Import-Module Terminal-Icons

# copy /b pic.jpg+tel.zip pix.jpg

function anonsurf {
    # Change to the specified directory
    Set-Location "D:\Dev\python\AnonSurf"
    & "D:\Dev\python\AnonSurf\env\Scripts\python.exe" "D:\Dev\python\AnonSurf\AnonSurf.py" start
    # Start-Process -FilePath "D:\Dev\python\AnonSurf\env\Scripts\python.exe" -ArgumentList "D:\Dev\python\AnonSurf\AnonSurf.py start" -NoNewWindow -Wait
}

function winutil {
    irm "https://christitus.com/win" | iex
}
${function:~} = { Set-Location ~ }
${function:v2} = {
    Set-Location "C:\Users\amirhosseindotzip\Desktop";
    # wget https://raw.githubusercontent.com/mahdibland/V2RayAggregator/master/Eternity.txt
    wget https://raw.githubusercontent.com/youfoundamin/V2rayCollector/main/mixed_iran.txt
}

# restart the windows explorer
Function rx {
    taskkill /im explorer.exe /f
    start explorer.exe
    exit
}
function file2image {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Name or relative path of the file you want to hide.")]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$HiddenFile,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = "Name or relative path of the cover image (e.g., image.jpg).")]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$ImageFile,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Name or relative path for the output image with the hidden file.")]
        [string]$OutputFile
    )

    try {
        # Resolve full paths
        $hiddenFilePath = Resolve-Path -Path $HiddenFile -ErrorAction Stop
        $imageFilePath = Resolve-Path -Path $ImageFile -ErrorAction Stop

        # Determine the output path
        if ([System.IO.Path]::IsPathRooted($OutputFile)) {
            $outputFilePath = $OutputFile
        }
        else {
            $currentDir = Get-Location
            $outputFilePath = Join-Path -Path $currentDir -ChildPath $OutputFile
        }

        # Check if output file already exists to prevent accidental overwrites
        if (Test-Path -Path $outputFilePath) {
            $overwrite = Read-Host "Output file '$outputFilePath' already exists. Do you want to overwrite it? (Y/N)"
            if ($overwrite.Trim().ToUpper() -ne 'Y') {
                Write-Host "Operation canceled by the user."
                return
            }
        }

        # Read bytes from the image and the file to hide
        $imageBytes = [System.IO.File]::ReadAllBytes($imageFilePath)
        $hiddenBytes = [System.IO.File]::ReadAllBytes($hiddenFilePath)

        # Combine the bytes using binary concatenation
        $combinedBytes = $imageBytes + $hiddenBytes

        # Write the combined bytes to the output file
        [System.IO.File]::WriteAllBytes($outputFilePath, $combinedBytes)

        Write-Host "Successfully created '$outputFilePath' with '$hiddenFilePath' hidden inside."
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}
 
# Directory Listing: Use `ls.exe` if available
if (Get-Command ls.exe -ErrorAction SilentlyContinue | Test-Path) {
    rm alias:ls -ErrorAction SilentlyContinue
    # Set `ls` to call `ls.exe` and always use --color
    ${function:ls} = { ls.exe --color @args }
    # List all files in long format
    ${function:l} = { ls -lF @args }
    # List all files in long format, including hidden files
    ${function:la} = { ls -laF @args }
    # List only directories
    ${function:ld} = { Get-ChildItem -Directory -Force @args }
}
else {
    # List all files, including hidden files
    ${function:la} = { ls -Force @args }
    # List only directories
    ${function:ld} = { Get-ChildItem -Directory -Force @args }
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

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

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
# function nvconf { nvim "C:\Users\amirhosseindotzip\AppData\Local\nvim\init.lua" }
# function nvfold { Set-Location C:\Users\amirhosseindotzip\AppData\Local\nvim }
# function nxfold { Set-Location D:\sourceerror\Web\frontend\._NEXT\ }
function hist { v "C:\Users\amirhosseindotzip\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
function histv { nvim "C:\Users\amirhosseindotzip\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
function histc { c "C:\Users\amirhosseindotzip\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
# {yt-dlp -x --audio-format mp3 --output '%(playlist_index)s-%(title)s.%(ext)s' $link
function yymp3 ($link) { yt-dlp -x --audio-format mp3 --output '%(title)s.%(ext)s' $link }

function ytplaylist ($link, $quality = 1080) {
    $format = "(bestvideo[height<=$quality]+bestaudio/best[height<=$quality])"
    yt-dlp -f $format -o "%(playlist_index)s - %(title)s.%(ext)s" $link
}
function Search-YouTubes ($keyword) {
    $searchUrl = "https://www.youtube.com/results?search_query=$keyword"
    $results = Invoke-WebRequest -Uri $searchUrl | Select-String -Pattern "video-title" | ForEach-Object { $_.Line }
    $results
}
function Search-Youtube {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Query,

        [Parameter(Mandatory = $false)]
        [string]$ApiKeyFilePath = "$env:USERPROFILE\.youtube_api_key"  # Default path
    )

    # **Read API Key from File**
    if (-Not (Test-Path -Path $ApiKeyFilePath)) {
        Write-Error "API key file not found at '$ApiKeyFilePath'. Please create the file and ensure it contains your YouTube API key."
        return
    }

    try {
        $apiKey = Get-Content -Path $ApiKeyFilePath -ErrorAction Stop | Select-Object -First 1
        $apiKey = $apiKey.Trim()  # Remove any leading/trailing whitespace
    }
    catch {
        Write-Error "Failed to read API key from '$ApiKeyFilePath'. Error: $_"
        return
    }

    if (-not $apiKey) {
        Write-Error "API key is empty. Please ensure the API key file contains a valid key."
        return
    }

    # Prompt for query if not provided
    if (-not $Query) {
        $Query = Read-Host "Enter YouTube search query"
    }

    # Encode the query for URL
    $encodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)

    # YouTube Search API endpoint
    $searchUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&maxResults=25&q=$encodedQuery&key=$apiKey"

    try {
        # Invoke the Search API
        $searchResponse = Invoke-RestMethod -Uri $searchUrl -Method Get

        if ($searchResponse.items.Count -eq 0) {
            Write-Host "No results found for '$Query'."
            return
        }

        # Extract Video IDs from search results
        $videoIds = $searchResponse.items | Select-Object -ExpandProperty id | Select-Object -ExpandProperty videoId

        # YouTube Videos API endpoint to get statistics (like viewCount)
        $videosUrl = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=$($videoIds -join ',')&key=$apiKey"

        # Invoke the Videos API
        $videosResponse = Invoke-RestMethod -Uri $videosUrl -Method Get

        # Create a hashtable to map Video IDs to their view counts
        $viewCounts = @{}
        foreach ($video in $videosResponse.items) {
            $viewCounts[$video.id] = $video.statistics.viewCount
        }

        # Prepare list for fzf with necessary information, separated by tab
        $videoList = $searchResponse.items | ForEach-Object {
            # Extract necessary details
            $title = $_.snippet.title -replace '"', '\"' -replace '\\', '\\\\'
            $channel = $_.snippet.channelTitle -replace '"', '\"' -replace '\\', '\\\\'
            $description = $_.snippet.description -replace '"', '\"' -replace '\\', '\\\\'
            $videoId = $_.id.videoId

            # Get view count from the hashtable; default to 0 if not found
            $viewCount = if ($viewCounts.ContainsKey($videoId)) { $viewCounts[$videoId] } else { "0" }

            # Process description to get the first five lines
            # $shortDescription = ($description -split "`n" | Select-Object -First 45) -join "\n"
            $shortDescription = ($description -split "\r\n|\n|\r" | Select-Object -First 15) -join "`n"

            # Combine details separated by tabs
            "$title`t$channel`t$viewCount`t$shortDescription`t$videoId"
        }

        # Define the preview command using printf
        $previewCommand = @"
printf '📺 Title: {1}\n🎩 Channel: {2}\n👀 Views: {3}\n\n📑 Description:\n{4}\n'
"@

        # Launch fzf with enhanced preview
        $selected = $videoList | & fzf.exe `
            --height 40% `
            --ansi `
            --delimiter "`t" `
            --with-nth 1 `
            --preview $previewCommand `
            --preview-window "right:60%:wrap" `
            --bind 'tab:toggle-preview'

        if ($selected) {
            # Split the selected line by tab to extract Video ID
            $parts = $selected -split "`t"
            $videoId = $parts[4]   # Video ID is now the 5th field
            $videoUrl = "https://www.youtube.com/watch?v=$videoId"

            # Open in default browser
            Start-Process $videoUrl
        }
        else {
            Write-Host "No selection made."
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}


function yy ($url) { yt-dlp -f "best[height<=720]" $url }
function sourceerror { Set-Location "D:\sourceerror" }
function fuck { Write-Output "Fuck Yeah"; }
Function x { explorer.exe . }
Function rc { Start-Process shell:RecycleBinFolder; exit; }
function sysinfo { powershell gwmi win32_bios }
Function m { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle $args }
Function mplay { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback $args }
Function mm { mpv --vo=null --video=no --no-video --term-osd-bar --no-resume-playback --shuffle "D:\Music" }
function cm { Set-Location D:\Music }
function d { Set-Location "D:\" }
function ShowWifiPasswords { (netsh wlan show profiles) | Select-String "\:(.+)$" | % { $name = $_.Matches.Groups[1].Value.Trim(); $_ } | % { (netsh wlan show profile name="$name" key=clear) }  | Select-String "Key Content\W+\:(.+)$" | % { $pass = $_.Matches.Groups[1].Value.Trim(); $_ } | % { [PSCustomObject]@{ PROFILE_NAME = $name; PASSWORD = $pass } } | Format-Table -AutoSize }







# Write-Host "
#      `e[93m_\/_
#       /\
#       `e[32m/\
#      /  \
#      /`e[33m~~`e[32m\`e[31m`e[5mo`e[25m
#     `e[32m/`e[34m`e[5mo`e[25m   `e[32m\
#    /`e[33m~~`e[93m*`e[33m~~~`e[32m\
#   `e[95m`e[5mo`e[25m`e[32m/     `e[96m`e[5mo`e[25m`e[32m\
#   /`e[33m~~~~~~~~`e[32m\
#  /`e[32m__`e[93m*`e[32m_______`e[32m\
#       `e[33m||
#     `e[37m\`e[33m====`e[37m/
#      \__/`e[0m
# "



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



# process info function


# Revised function to get process information
function pinfo {
    param(
        [Parameter(Position = 0)]
        [alias("pn")]
        [string]$ProcessName,
    
        [Parameter(Position = 1)]
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
        [Parameter(Position = 0, Mandatory = $true)]
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


function lazynvim() {
    $env:NVIM_APPNAME = "lazynvim"
    nvim $args
}
function nvchad() {
    $env:NVIM_APPNAME = "NvChad"
    nvim $args
}
function astronvim() {
    $env:NVIM_APPNAME = "AstroNvim"
    nvim $args
}
function v() {
    $env:NVIM_APPNAME = "AstroNvim"
    nvim $args
}
function jnvim() {
    $env:NVIM_APPNAME = "jnvim"
    nvim $args
}
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
        $editorList = @( "astronvim", "code", "vim", "nvim", "notepad", "qview", "mpv", "firefox", "chrome", "jq")
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
    }
    else {
        Write-Host "WebStorm not found at path: $webstormPath"
    }
}

function bt {
    param(
        [int]$IntervalMinutes = 20
    )

    while ($true) {
        # Insert the code to generate the ringing sound here
        # For example, you can use the [console]::beep() method

        [console]::beep(500, 1000)  # Example: Generate a beep sound

        Write-Host "Ringing!"

        # Wait for the specified interval in minutes
        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
}



function Select-YTDPLOptions {
    param(
        [Parameter(Mandatory = $true)]
        [string]$URL
    )

    # Function to format and display formats in a colored manner
    function Format-FormatList {
        param(
            [array]$formats,
            [string]$type
        )

        $formattedList = @()
        foreach ($format in $formats) {
            switch ($type) {
                "video" {
                    $formatCode = $format.format_id
                    $ext = $format.ext
                    $resolution = if ($format.height) { "$($format.width)x$($format.height)" } else { "N/A" }
                    $vcodec = $format.vcodec
                    $fps = if ($format.fps) { "$($format.fps)fps" } else { "N/A" }
                    $filesize = if ($format.filesize) { "{0:N2}MB" -f ($format.filesize / 1MB) } else { "N/A" }
                    "$formatCode | $ext | $resolution | v: $vcodec | FPS: $fps | Size: $filesize" | 
                    Out-String | 
                    ForEach-Object { "`e[32m$_`e[0m" } # Green color
                }
                "audio" {
                    $formatCode = $format.format_id
                    $ext = $format.ext
                    $acodec = $format.acodec
                    $abr = if ($format.abr) { "$($format.abr)kbps" } else { "N/A" }
                    $filesize = if ($format.filesize) { "{0:N2}MB" -f ($format.filesize / 1MB) } else { "N/A" }
                    "$formatCode | $ext | a: $acodec | ABR: $abr | Size: $filesize" | 
                    Out-String | 
                    ForEach-Object { "`e[34m$_`e[0m" } # Blue color
                }
            }
        }
        return $formattedList
    }

    try {
        Write-Host "🔍 Fetching video information, please wait..." -ForegroundColor Cyan

        # Fetch video information in JSON format
        $infoJson = yt-dlp --dump-json "$URL" | ConvertFrom-Json

        $formats = $infoJson.formats

        if (-not $formats) {
            Write-Error "❌ No formats found for the provided URL."
            return
        }

        # Categorize formats
        $videoFormats = $formats | Where-Object { $_.vcodec -ne 'none' }
        $audioFormats = $formats | Where-Object { $_.acodec -ne 'none' }

        if ($videoFormats.Count -eq 0) {
            Write-Error "❌ No video formats available for this URL."
            return
        }

        if ($audioFormats.Count -eq 0) {
            Write-Error "❌ No audio formats available for this URL."
            return
        }

        # Prepare video display list
        $videoDisplayList = Format-FormatList -formats $videoFormats -type "video"

        # Select Video Format
        Write-Host "`n🎥 -- Select Video Format --" -ForegroundColor Yellow
        $selectedVideo = $videoDisplayList | fzf --prompt="Select VIDEO format: " --height=60% --layout=reverse --border --ansi

        if ([string]::IsNullOrEmpty($selectedVideo)) {
            Write-Host "❌ No video format selected. Exiting." -ForegroundColor Red
            return
        }

        # Extract video format ID
        $videoFormatId = ($selectedVideo -split "\|")[0].Trim()

        Write-Host "✅ Selected Video Format ID: $videoFormatId" -ForegroundColor Green

        # Prepare audio display list
        $audioDisplayList = Format-FormatList -formats $audioFormats -type "audio"

        # Select Audio Format
        Write-Host "`n🎵 -- Select Audio Format --" -ForegroundColor Yellow
        $selectedAudio = $audioDisplayList | fzf --prompt="Select AUDIO format: " --height=60% --layout=reverse --border --ansi

        if ([string]::IsNullOrEmpty($selectedAudio)) {
            Write-Host "❌ No audio format selected. Exiting." -ForegroundColor Red
            return
        }

        # Extract audio format ID
        $audioFormatId = ($selectedAudio -split "\|")[0].Trim()

        Write-Host "✅ Selected Audio Format ID: $audioFormatId" -ForegroundColor Green

        # Define download options
        $outputTemplate = "%(title)s.%(ext)s"
        $downloadOptions = "-f", "$videoFormatId+$audioFormatId", "-o", "`"$outputTemplate`""

        Write-Host "`n⬇️ Starting download..." -ForegroundColor Cyan

        # Start the download with the selected formats
        yt-dlp $downloadOptions "$URL"

        Write-Host "🎉 Download completed successfully!" -ForegroundColor Green

    }
    catch {
        Write-Error "❌ An error occurred: $_"
    }
}




# mpv videoName -sub-file sub1 -sub-file sub2 -secondary-sid 2
function ff {
    param(
        [string]$searchTerm
    )
    $firefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"  # Update the path to your Firefox installation if needed
    $searchUrl = "https://www.google.com/search?q=$searchTerm"  # Update with your preferred search engine URL
    
    & $firefoxPath $searchUrl
}

# digitalClock
# Invoke-Expression (&starship init powershell)
# (ptr completion) -join "`n" | iex
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })
