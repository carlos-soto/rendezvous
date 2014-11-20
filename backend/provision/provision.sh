#!/bin/bash
# Provisioning script for School Pages Web project

apt-get update

# Install prerequisites
apt-get -y install curl git libxslt-dev libxml2-dev libicu-dev libcurl4-openssl-dev libcurl4-openssl-dev nodejs npm

# Install mysql
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server mysql-client libmysqlclient-dev

# Add db user
mysql -u root < /vagrant/provision/create_user.sql


# Switch to the vagrant user in order to install RVM with Ruby 2.0.0
su vagrant << EOF


	# Importing ”Michal Papis (RVM signing) <mpapis@gmail.com>" public Key into our Keychain
        # (So we can download Ruby)
        gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

	# Install rvm and ruby
	cd /vagrant
	\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.0.0
	source /home/vagrant/.rvm/scripts/rvm
	rvm use 2.0.0

	# Bundle install all the gems needed
	gem install bundler
	bundle install

	# Set up database schema
	rake db:setup

	# Install nginx+passenger
	gem install passenger
	export rvmsudo_secure_path=1
	rvmsudo passenger-install-nginx-module --auto
	wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh
	sudo mv init-deb.sh /etc/init.d/nginx
	sudo chmod +x /etc/init.d/nginx
	sudo /usr/sbin/update-rc.d -f nginx defaults
	sudo cp /vagrant/provision/nginx.conf /opt/nginx/conf/nginx.conf
	sudo service nginx start

EOF