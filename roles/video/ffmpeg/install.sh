# https://www.ffmpeg.org/download.html#repositories

# https://github.com/SergeyPirogov/video-recorder-java

# yum install -y nasm

# git clone https://git.ffmpeg.org/ffmpeg.git

# ( cd ffmpeg && ./configure )

# ( cd ffmpeg && make install )


docker pull jrottenberg/ffmpeg

# docker run jrottenberg/ffmpeg -stats  \
#         -i http://archive.org/download/thethreeagesbusterkeaton/Buster.Keaton.The.Three.Ages.ogv \
#         -loop 0  \
#         -final_delay 500 -c:v gif -f gif -ss 00:49:42 -t 5 - > trow_ball.gif

