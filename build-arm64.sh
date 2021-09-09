sudo docker run --rm --privileged multiarch/qemu-user-static:register --reset
sudo docker build --build-arg HTTP_PROXY=http://192.168.2.216:7890 --build-arg HTTPS_PROXY=http://192.168.2.216:7890  --tag=hextec/media-ffmpeg:1.0.820210909-RELEASE-arm64 --output type=local,dest=build -f arm64.dockerfile .
