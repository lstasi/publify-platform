#Publify Platform
 * Vagrant based project to deploy 3 Servers, Load Balancer, Application (Publify) and DB (mysql)
 
#Requirements
 *Vagrant 1.7.2
 *Virtual Box 4.3.26
 *3G RAM ( If not, change v.memory on the Vagrant file)
 
#Instructions
	Just Run Vagrant up on the project folder.
	Servers ip address can be modified from default.pp
	LB is 192.168.56.2 (Virtual Box Host Only Network)
	WEB 192.168.56.10
	DB 192.168.56.20

You should be able to access http://192.168.56.2

Also you can access haproxy stats in 

http://192.168.56.2:8080/stats 
	user: 3scale
	pass: test
