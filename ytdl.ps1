function ytdl {

    $path = "$env:USERPROFILE\Documents\youtube-dl"
    function testexe(){
        If (!(Test-Path "$path")) {
            New-Item -Path "$path" -ItemType Directory -Force | Out-Null
            New-Item -Path "$path\MP3" -ItemType Directory -Force | Out-Null
            New-Item -Path "$path\MP4" -ItemType Directory -Force | Out-Null
            Write-Host "Neue Ordner $env:USERPROFILE\Documents\youtube-dl angelegt"
        }

        $count = 0
        if (!(Test-Path $path\youtube-dl.exe -PathType Leaf)) {
            Write-Host "youtube-dl.exe ist nicht vorhanden"
            Start-Process "https://www.youtube-dl.org/"
            $count = $count +1
        }
        else {
            Set-Location $path
            .\youtube-dl.exe -U
        }
        if (!(Test-Path $path\ffmpeg.exe -PathType Leaf)) {
            Write-Host "ffmpeg.exe ist nicht vorhanden"
            Start-Process "https://www.gyan.dev/ffmpeg/builds/"
            $count = $count +1
        }
        $py = ((Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Python").Length -gt 0
        if (!($py = $True )){
            Write-Host "Python ist nicht installiert!"
            Start-Process "https://www.python.org/downloads/"
            $count = $count +1
        }
        if ($count -ne 0){
            Write-Host "Fehlende Software downloaden!"
        }
    }

    function ytdl2mp3 {

        Set-Location $path
        $ytinput = Read-Host -Prompt 'Paste URL here'
        if ($ytinput -match '(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})') {
            .\youtube-dl.exe --extract-audio --audio-format mp3 -o "$path\MP3\%(title)s.%(ext)s" $ytinput --no-check-certificate --yes-playlist 
        }
    }
    function ytdl2mp4 {

        Set-Location $path
        $ytinput = Read-Host -Prompt 'Paste URL here'
        if ($ytinput -match '(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})') {
            .\youtube-dl.exe -o "$path\MP4\%(title)s.%(ext)s" $ytinput --no-check-certificate --yes-playlist 
        }
    }
    function ytdl2mp3multiplefiles(){

        Function Select-FolderDialog{
            param([string]$Description="Select Folder",[string]$RootFolder="Desktop")

            [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
                Out-Null     

            $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
            $objForm.Rootfolder = $RootFolder
            $objForm.Description = $Description
            $Show = $objForm.ShowDialog()
            If ($Show -eq "OK") {
                Return $objForm.SelectedPath
            }
            elseif ($Show -eq "Cancel") {
                Return "$path\MP3"
            }
            else {
                break
            }
        }
        $folder = Select-FolderDialog

        Set-Location $path
        If (!(Test-Path ".\list.txt")) {
            New-Item .\list.txt | Out-Null
        }
        notepad.exe .\list.txt | Out-Null
        
        foreach ($line in Get-Content .\list.txt) {
            if ($line -match '(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})') {
                .\youtube-dl.exe --extract-audio --audio-format mp3 -o "$folder\%(title)s.%(ext)s" $line --no-check-certificate --yes-playlist
            }
        }
        Remove-Item .\list.txt
    }
    function ytdl2mp4multiplefiles(){

        Function Select-FolderDialog{
            param([string]$Description="Select Folder",[string]$RootFolder="Desktop")

            [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
                Out-Null     

            $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
            $objForm.Rootfolder = $RootFolder
            $objForm.Description = $Description
            $Show = $objForm.ShowDialog()
            If ($Show -eq "OK") {
                Return $objForm.SelectedPath
            }
            elseif ($Show -eq "Cancel") {
                Return "$path\MP4"
            }
            else {
                break
            }
        }
        $folder = Select-FolderDialog

        Set-Location $path
        If (!(Test-Path ".\list.txt")) {
            New-Item .\list.txt | Out-Null
        }
        notepad.exe .\list.txt | Out-Null
        
        foreach ($line in Get-Content .\list.txt) {
            if ($line -match '(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})') {
                .\youtube-dl.exe -o "$folder\%(title)s.%(ext)s" $line --no-check-certificate --yes-playlist 
            }
        }
        Remove-Item .\list.txt
    }
    
    testexe
    Write-Host $count
    if ($null -eq $count){
        Write-Host "Youtube DL Automatisation" -ForegroundColor blue
        Write-Host "" 
        Write-Host "    1. ytdl2mp3 single"
        Write-Host "    2. ytdl2mp4 single"
        Write-Host "    3. ytdl2mp3 multiple"
        Write-Host "    4. ytdl2mp4 multiple"
        Write-Host "    5. help"
        Write-Host ""
        Write-Host ""  
        $answer = read-host "Auswahl" 
        
        switch ($answer) {
            "1" { ytdl2mp3; break }
            "2" { ytdl2mp4; break}
            "3" { ytdl2mp3multiplefiles; break}
            "4" { ytdl2mp4multiplefiles; break }
            "5" { Write-Host "Selber Schuld" }
            Default { Write-Host "Auswahl unbekannt" }
        }
    }
    else{
        break
    }
    
}