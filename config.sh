RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
NC='\033[0m'
PURPLE='\033[0;35m'
WORKING_DIR=$(pwd)
cd ~
HOME=$(pwd)
cd ${WORKING_DIR}

# ------------ modify from here ------------

# Apt config
apt="NO"

# Apt-get config
apt_get="NO"

# Package( vim , git , htop , build-essential , cmake , automake )
package="NO"

# Git config
git="NO"
git_email="YOUR_EMAIL@EXAMPLE.COM"
git_username="SECRET"

# vimrc
vimrc="NO"

# opencv
opencv="NO"

# lamp server
lamp_server="YES"
mysql_password="YOUR_PASSWORD"
mysql_password_confirm="YOUR_PASSWORD"
