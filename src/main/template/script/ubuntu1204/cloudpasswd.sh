sudo apt-get update -y -q
sudo apt-get upgrade -y -q
sudo apt-get install --no-install-recommends -q -y --force-yes wget
sudo apt-get install --no-install-recommends -q -y --force-yes whois
wget http://download.cloud.com/templates/4.2/bindir/cloud-set-guest-password.in
sudo mv cloud-set-guest-password.in /etc/init.d/cloud-set-guest-password
sudo chmod +x /etc/init.d/cloud-set-guest-password
sudo update-rc.d cloud-set-guest-password defaults 98
sudo echo "manual" | sudo tee /etc/init/network-manager.override
sudo echo "\$i sudo start network-manager" /etc/rc.local

