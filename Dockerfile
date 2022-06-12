FROM debian
MAINTAINER amfor 


# Installing systemd in docker  container 
# See https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container
USER root
ENV container docker
RUN apt-get -y update; apt-get clean all
RUN  apt-get -y install systemd; apt-get clean all
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

# install libimobiledevice-glue-dev (usbmuxd req)
RUN apt-get install -y \
	build-essential \
	pkg-config \
	checkinstall \
	git \
	autoconf \
	automake \
	libtool-bin \
	libplist-dev 

RUN git clone https://github.com/libimobiledevice/libimobiledevice-glue.git
WORKDIR /libimobiledevice-glue
RUN ./autogen.sh; make;  make install


# usbmuxd dependencies
RUN apt-get install -y \
	build-essential \
	pkg-config \
	checkinstall \
	git \
	autoconf \
	automake \
	libtool-bin \
	libplist-dev \
	libusbmuxd-dev \
	libimobiledevice-dev \
	libusb-1.0-0-dev \
	udev

#usbmuxd install
WORKDIR /
RUN git clone https://github.com/libimobiledevice/usbmuxd.git
WORKDIR ./usbmuxd
RUN ./autogen.sh; make;  make install

# AltServer install
# pre-install
WORKDIR /
RUN apt-get install -y libavahi-compat-libdnssd-dev
RUN apt-get install -y curl 
RUN curl -o AltServer -0 https://github.com/NyaMisty/AltServer-Linux/releases/download/v0.0.5/AltServer-aarch64 
