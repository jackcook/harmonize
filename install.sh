rm -rf Frameworks
mkdir Frameworks
cd Frameworks
wget "https://github.com/spotify/ios-sdk/archive/master.zip"
unzip master.zip
rm master.zip
mv ios-sdk-master/Spotify.framework Spotify.framework
rm -rf ios-sdk-master
wget "http://www.rdio.com/media/static/developer/ios/rdio-ios.tar.gz"
tar -xzvf rdio-ios.tar.gz
rm rdio-ios.tar.gz
mv rdio-ios-*/Rdio.framework Rdio.framework
rm -rf rdio-ios*
pod install
