# linux_setup
automatic setup for **ubuntu 16.04**

### Features
+ apt update
+ apt upgrade
+ install vim , git , htop , build-essential , cmake , automake
+ configure .vimrc
+ configure git
+ install opencv
+ install caffe
+ install openpose
+ install docker

### Beta Features
+ install lamp-server

### Clone Repo
```=1
git clone https://github.com/ambersun1234/linux_setup.git
```

### Set Config
You must open the [config.sh](https://github.com/ambersun1234/linux_setup/blob/master/config.sh) file to configure setup<br>the following is part of the [config.sh](https://github.com/ambersun1234/linux_setup/blob/master/config.sh) file
```=1
# Apt config
apt="NO"

# Apt-get config
apt_get="NO"

# Package( vim , git , htop , build-essential , cmake , automake )
package="NO"
```
+ type
    **"YES"** if you want to install or configure
     , **"NO"** if you ***don't*** want to install or configure
    after the equal sign.
    + Caution! the word "YES" and "NO" are both ***case sensitive***

### Usage
please run with ***sudo***
```=1
cd linux_setup
sudo ./setup.sh
```
