#!/bin/bash
#Automatic Debian Video Downloader
#Simple script by yours truly.
#
#
#
#Still buggy so take it easy. ;)
#
#It would be awesome if you'd provide multi-distro support
if [ "$1" = "h" ]; then
	echo "USAGE: ./download.sh <URL>"
	exit
elif [ "$1" = NULL ]; then 
	echo "" 
else
	echo "USAGE: ./download.sh <URL>"
	exit
fi

which youtube-dl >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "youtube-dl loaded."
else 
	echo "[!] youtube-dl was not found. Please wait while we download it for you."
	aptitude install youtube-dl
fi

which ffmpeg >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "ffmpeg loaded."
else
	echo "[!] ffmpeg was not found. Please wait while we download it for you."
	aptitude install ffmpeg
fi

echo "Please be patient while we check environment parameters for your download. If errors persist, we'll fix them for you."
echo ""
echo "Checking Directories"
ls VIDEOS >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "VIDEOS folder is present."
else
	mkdir VIDEOS/
	echo "VIDEOS folder was not found.Making it."
fi


ls AUDIOS >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "AUDIOS folder is present"
else 
	mkdir AUDIOS/
	echo "AUDIOS folder was not found.Making it."
fi

#Checking if any video or audio file is present within the current folder.
#This is to ensure that no errors during downloading & converting (if specified) will show.
#flv, mp4 and webm
videocheck () {
ls *.flv >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "FLV was found.Now moved"
	mv *.flv VIDEOS/
else
	echo "FLV: Clear"
fi

ls *.webm >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "WEBM was found.Now moved"
	mv *.webm VIDEOS/
else
	echo "WEBM: Clear"
fi

ls *.mp4 >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "MP4 was found.Now moved"
	mv *.mp4 VIDEOS/
else
	echo "MP4: CLEAR"
fi
}

audiocheck () {
#aac,mp3,ogg,m4a,opus,vorbis,wav
ls *.aac >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "AAC was found.Now moved"
	mv *.aac AUDIOS	
else 
	echo "AAC:Clear"
fi

ls *.mp3 >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "MP3 was found.Now moved"
	mv *.mp3 AUDIOS
else
	echo "MP3: Clear"
fi

ls *.ogg >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "OGG was found.Now moved"
	mv *.ogg AUDIOS
else
	echo "OGG: Clear"
fi

ls *.m4a >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "M4A was found.Now moved"
	mv *.m4a AUDIOS
else
	echo "M4A: Clear"
fi

ls *.opus >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "OPUS was found.Now moved"
	mv *.opus AUDIOS
else
	echo "OPUS:Clear"
fi

ls *.vorbis >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "VORBIS was found.Now moved"
	mv *.vorbis AUDIOS
else
	echo "VORBIS:Clear"
fi

ls *.wav >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "WAV was found.Now moved"
	mv *.wav AUDIOS
else
	echo "WAV:Clear"
fi
}

videocheck
audiocheck
echo "Now downloading $1"
youtube-dl --abort-on-error -q -F "$1"
echo "Please choose what video format you want to download?"
echo "***THIS MAY TAKE TIME DEPENDING ON VIDEO QUALITY AND LENGTH"
read ch
youtube-dl --abort-on-error -t -f "$ch" "$1"
ls *.mp4 >/dev/null 2>&1
if [ $? -eq 0 ]; then
	VI=`ls *.mp4`
	V=$VI.mp3
	echo "Do you want to convert it to MP3 Audio file?[y] or [n]"
	read chc
	if [ $chc = "y" ]; then
		ffmpeg -i "$VI" "$V"
		#lame "$V"
		echo "Do you want to delete the video file downloaded?[y] or [n]"
		read nch
		if [ $nch =  "y" ]; then
			rm "$VI"
		else
			echo "Video file retained."
		fi
	else
		echo "Skipping conversion."
	fi
else
	echo '[!] An error occured during download'
fi

echo "+++++++++++++++++++++++++DOWNLOAD COMPLETE++++++++++++++++++++++++++++++"
echo "Do you want to move downloaded files into AUDIOS & VIDEOS folders?[y] or [n]"
read chs
if [ $chs = "y" ]; then
	videocheck
	audiocheck
else
	echo "Now exiting."
	exit
fi
