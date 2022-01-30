for m in *.mpg *.mpeg *.wmv *.avi; do
    echo $m...
    "C:/Program Files/Windows Media Player/wmplayer.exe" "file:///$PWD/$m" &
    #"C:/Program Files/internet explorer/iexplore.exe" "file:///$PWD/$m" &
    #"C:/Program Files/Real/RealPlayer/realplay.exe" "file:///$PWD/$m" &
    sleep 20
    #ps -eaf | grep -v awk | awk '/realplay/{print $2}'
    #kill -9 "`ps -eaf | grep -v awk | awk '/realplay/{print $2}'`"
done
