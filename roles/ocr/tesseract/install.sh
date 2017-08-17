

yum -y install tesseract

#
# Tesseract test data
#
git clone -n https://github.com/tesseract-ocr/tessdata.git --depth 1

# git archive --remote=https://github.com/tesseract-ocr/tessdata.git HEAD eng.traineddata

( cd tessdata && git checkout HEAD eng.traineddata )
( cd tessdata && git checkout HEAD osd.traineddata )

( cd tessdata && cp eng.traineddata /usr/share/tesseract/tessdata/. )
( cd tessdata && cp osd.traineddata /usr/share/tesseract/tessdata/. )


#
# Get the tesseract and leptonica libraries
#
sudo yum -y install epel-release
sudo yum -y install tesseract-devel leptonica-devel




git clone https://gitlab.com/canzea/pa-automation.git

( cd pa-automation && g++ tesseract.cc -ltesseract -llept -o sample )

( cd pa-automation && ./sample )




# git clone https://github.com/tesseract-ocr/tesseract.git tesseract-ocr

# ( cd tesseract-ocr && ./autogen.sh )

# ( cd tesseract-ocr && ./configure )
