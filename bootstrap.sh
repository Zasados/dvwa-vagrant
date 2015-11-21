#!/bin/bash - 
#===============================================================================
#
#          FILE: bootstrap.sh
# 
#         USAGE: ./bootstrap.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 24.02.2014 09:23
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

apt-get update

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password p@ssw0rd'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password p@ssw0rd'
sudo apt-get update
sudo apt-get -y install mysql-server-5.5 php5-mysql apache2 php5 vim git php5-gd

dir="/root/DVWA"
if [[ -e $dir  ]]; then
    cd "$dir" && git pull --rebase
else
    cd "/root/"
    git clone https://github.com/RandomStorm/DVWA
fi

cp -r ~/DVWA/* /var/www
sudo chmod -R 777 /var/www/hackable/uploads/
sudo chmod -R 777 /var/www/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt

echo "display_errors = On" > /etc/php5/conf.d/z_custom.ini

sudo sed -i -e 's/index.html/index.php/1' /etc/apache2/mods-enabled/dir.conf
sudo sed -i -e 's/index.php/index.html/2' /etc/apache2/mods-enabled/dir.conf
sudo sed -i -e 's/allow_url_include = Off/allow_url_include = On/g' /etc/php5/apache2/php.ini

sudo service apache2 restart
