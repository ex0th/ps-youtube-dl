# ps-youtube-dl
Powershell youtube-dl automatisation for Windows

# Requirements:

At least Python 2.7 or higher                                      https://python.org/downloads

youtube-dl.exe                                                     https://youtube-dl.org

ffmpeg (which includes ffmpeg.exe, ffprobe.exe, ffplay.exe)        https://ffmpeg.org

Paste the script in your Powershell Profile or execute it directly
# This script works in "$env:USERPROFILE\Documents\youtube-dl"

Call the function "ytdl", which looks for required software and updates youtube-dl.exe
Then you can choose between 4 different functions:

ytdl2mp3               #Downloads single Video and converts it to MP3-File, playlist links also work
 
ytdl2mp4               #Downloads single Video and converts it to MP4-File
  
ytdl2mp3multiplefiles  #Downloads multiple Videos and converts them to MP3-Files (after calling function it asks for destination folder, PS Window may be in Front), playlist                             links should also work
  
ytdl2mp4multiplefiles  #Downloads multiple Videos and converts them to MP4-Files (after calling function it asks for destination folder, PS Window may be in Front)
