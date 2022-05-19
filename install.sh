vgl_version="3.0.1"
nvidia_version="460.73.01"

apt-get --reinstall install freeglut3-dev mesa-utils libegl1-mesa xorg xserver-xorg-core x11-xserver-utils libxrandr-dev lightdm 

service lightdm stop
bash ./NVIDIA-Linux-x86_64-$nvidia_version.run --no-cc-version-check

nvidia-xconfig -a --allow-empty-initial-configuration --virtual=1920x1200 --busid $(nvidia-xconfig --query-gpu-info | grep "PCI BusID :" | awk '{print $4}')

sed -i "/$(nvidia-xconfig --query-gpu-info | grep "PCI BusID :" | awk '{print $4}')/a\    Option "HardDPMS" "false"" /etc/X11/xorg.conf

service lightdm stop

wget https://downloads.sourceforge.net/project/virtualgl/$vgl_version/virtualgl_$vgl_version_amd64.deb
dpkg -i virtualgl_$vgl_version_amd64.deb

rmmod nvidia_drm
rmmod nvidia_modeset
rmmod nvidia_uvm
rmmod nvidia

/opt/VirtualGL/bin/vglserver_config 

service lightdm start
