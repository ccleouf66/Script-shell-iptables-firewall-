#!/bin/bash

# Script qui est executé au démarge du serveur pour faire les règles de iptable

iptables -F
iptables -X

# On bloc tout le trafic entrant
iptables -P INPUT DROP

#http
	iptables -A INPUT -p tcp --dport 80 -j ACCEPT

#https
	iptables -A INPUT -p tcp --dport 443 -j ACCEPT

#ssh
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#localhost loopback 127.0.0.1
iptables -A INPUT -i lo -j ACCEPT

#ping
	iptables -A INPUT -p icmp -j ACCEPT

#ftp
	iptables -A INPUT -p tcp -m tcp --dport 21 -j ACCEPT
	iptables -A INPUT --match helper --match conntrack --protocol tcp --helper ftp --ctstate RELATED -j ACCEPT
	#plage de port ftp pour le mode passif c'est le serveur qui impose un de ces ports et non le client
		iptables -A INPUT -p tcp -m tcp --dport 21000:21100 -j ACCEPT

#connexion déjà etablie
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#SMTP 
	iptables -A INPUT -p tcp -m tcp --dport 25 -j ACCEPT

#IMAP
	iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT