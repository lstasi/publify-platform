#!/bin/bash
if [ ! -f "/.provision/.puppet_installed" ]
then
   	echo "Install puppet"
	sudo yum install puppet -y
	mkdir -p /.provision
	touch /.provision/.puppet_installed
fi
echo "Puppet already installed"

