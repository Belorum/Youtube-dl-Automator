#!/bin/bash

menu=0

while [ $menu != 8 ]; do

clear

# Menu of youtube-dl options
echo "Menu Options"
echo "----------------------------------"
echo "1. Install youtube-dl"
echo "2. Download Youtube Video"
echo "3. Download Youtube Playlist"
echo "4. Download All Videos from User"
echo "5. Extract MP3 Audio from Video"
echo "6. Update youtube-dl"
echo "7. Uninstall youtube-dl"
echo "8. Exit"

read -p 'Please select menu option: ' menu

if [ $menu == 1 ]; then
    # Checks to see if running as root
    if [ "$EUID" != 0 ]; then
        echo "Please run as root"
    else
        # Checks to see if youtube-dl is already installed
        if command -v youtube-dl >/dev/null 2>&1; then
        echo "youtube-dl is already installed"
        else
        # Installs youtube-dl and makes it executable
        sudo wget https://yt-dl.org/latest/youtube-dl -O /usr/local/bin/youtube-dl && sudo chmod a+x /usr/local/bin/youtube-dl && hash -r
        fi
    fi
elif [ $menu == 2 ]; then
    read -p 'Enter the URL of the video: ' video_url
    youtube-dl "$video_url"
    clear
elif [ $menu == 3 ]; then
    read -p 'Would you like to archive this playlist to download new videos later? (y/n) ' archive # Archiving allows you to skip downloading previously downloaded playlist videos
    if [ $archive == 'y' ]; then
        read -p 'Enter Archive name: ' archivename
        read -p 'Enter playlist folder name: ' plfoldername
        read -p 'Enter or Paste Playlist ID or URL Here: ' playlistid
        if [[ $playlistid == *"www.youtube.com"* ]]; then
            youtube-dl --download-archive $archivename.txt -o ~/Playlists/$plfoldername/%\(title\)s.%\(ext\)s $playlistid
        elif [[ $playlistid == *"list=PL"* ]]; then
            youtube-dl --download-archive $archivename.txt -o ~/Playlists/$plfoldername/%\(title\)s.%\(ext\)s "https://www.youtube.com/playlist?list="$playlistid
        else
            echo "This doesn't appear to be a valid link, please double check"
        fi
    elif [ $archive == 'n' ]; then
        read -p 'Enter playlist folder name: ' plfoldername
        read -p 'Enter or Paste Playlist ID Here: ' playlistid
        if [[ $playlistid == *"www.youtube.com"* ]]; then
            youtube-dl -o ~/Playlists/$plfoldername/%\(title\)s.%\(ext\)s $playlistid
        elif [[ $playlistid == *"list=PL"* ]]; then
            youtube-dl -o ~/Playlists/$plfoldername/%\(title\)s.%\(ext\)s "https://www.youtube.com/playlist?list="$playlistid
        fi
    else
        echo "Not quite sure what you were trying to enter..."
        echo "Continuing without archiving..."
        read -p 'Enter playlist folder name: ' plfoldername
        read -p 'Enter or Paste Playlist ID Here: ' playlistid
        if [[ $playlistid == *"www.youtube.com"* ]]; then
            youtube-dl -o ~/Playlists/$plfoldername/%\(title\)s.%\(ext\)s $playlistid
        elif [[ $playlistid == *"list=PL"* ]]; then
            youtube-dl -o ~/Playlists/$plfoldername/%\(title\)s.%\(ext\)s "https://www.youtube.com/playlist?list="$playlistid
        fi
    fi
elif [ $menu == 4 ]; then
    read -p 'Enter Youtube User Name: ' user
    youtube-dl -o ~/$user/%\(title\)s.%\(ext\)s ytuser:$user
elif [ $menu == 5 ]; then
    echo "Still working on getting audio extraction to work for MP3"
    echo "Currently only downloads available audio"
    #read -p 'Enter the URL of the video: ' video_url
    #youtube-dl --extract-audio --audio-format mp3 $video_url
elif [ $menu == 6 ]; then
    echo "Current Version"
    echo "---------------"
    youtube-dl --version
    echo " "
    youtube-dl -U
elif [ $menu == 7 ]; then
    echo "Are you sure you want to remove youtube-dl? (y/n) " uninstallchoice
    if [ $uninstallchoice == 'y' ]; then
        sudo apt-get remove -y youtube-dl
    elif [ $uninstallchoice == 'n' ]; then
    clear
    fi
elif [ $menu == 8 ]; then
    clear
else
    echo "Invalid input"
fi
done