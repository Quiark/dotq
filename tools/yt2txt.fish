set -x VIDURL $argv[1]
set -x WORK .

~/install/py3_11stuff/bin/yt-dlp -k -o $WORK/dl.vid $VIDURL

ffmpeg -i $WORK/dl.vid -map 0:1 -acodec pcm_s16le -ac 2 -ar 16000 $WORK/audio.wav

 ~/AI/whisper.cpp/result/bin/whisper-cpp $WORK/audio.wav -m ~/AI/whisper.cpp/models/ggml-medium.en.bin > $WORK/whisper.txt
