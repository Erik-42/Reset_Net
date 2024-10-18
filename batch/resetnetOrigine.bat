//-Reset connexion reseaux - Erik-42
//netsh interface ipv4 set address name="nomdelinterface" static IP netmask passerelle

open=cmd

//-Show config-
//netsh interface show interface
//netsh interface ipv4 show config
//netsh interface ipv6 show config
//netsh int tcp show global
//netsh interface show interface

//DNS modify
//Delete DNS
//netsh inter ipv4 delete dns LAN all
//netsh inter ipv6 delete dns LAN all

//Pour changer les DNS:
//netsh interface ipv4 set dnsservers "Nombre_red" static IP_DNS primary
//netsh interface ipv6 set dnsservers "Nombre_red" static IP_DNS primary
//Pour ajouter un DNS secondaire:
//netsh interface ipv4 add dnsservers "Nombre_red" IP_DNS index=2
//netsh interface ipv6 add dnsservers "Nombre_red" IP_DNS index=2
//Exemple: netsh interface ipv4 set dnsservers "Ethernet" static 8.8.8.8 primary
//Exemple: netsh interface ipv6 set dnsservers "Ethernet" static 2001:4860:4860::8888 primary

//changer les serveurs DNS
//netsh interface ipv4 set dns name="nomdelinterface" static DNS_SERVER
//netsh interface ipv4 set dns name="Wi-Fi" static 1.1.1.1
//netsh interface ipv4 set dns name="Ethernet" static 1.1.1.1
//netsh interface ipv4 set dns name="Ethernet2" static 1.1.1.1
//netsh interface ipv4 set dns name="Ethernet3" static 1.1.1.1

//serveur DNS secondaire
//netsh interface ipv4 set dns name="nomdelinterface" static DNS_SERVER index=2
//netsh interface ipv4 set dns name="Wi-Fi" static 1.0.0.1 index=2
//netsh interface ipv4 set dns name="Ethernet" static 1.0.0.1 index=2
//netsh interface ipv4 set dns name="Ethernet2" static 1.0.0.1 index=2
//netsh interface ipv4 set dns name="Ethernet3" static 1.0.0.1 index=2


//CloudFlare DNS
//- Pour IPv4 : Primaire 1.1.1.1, Secondaire 1.0.0.1
//- Pour IPv6 : Primaire 2606:4700:4700::1111, Secondaire 2606:4700:4700::1001
//Google
//- Pour IPv4 : 8.8.8.8, 8.8.4.4
//- Pour IPv6 : 2001:4860:4860::8888, 2001:4860:4860::8844
//OpenDNS
//- Pour IPv4 : 208.67.222.222, 208.67.220.220
//- Pour IPv6 : 2620:0:ccc::2, 2620:0:ccd::2

ipconfig /flushdns

netsh int ip reset ..\tcpipreset.txt

//Bluetooth
netsh interface IPv4 set dnsserver "Connexion réseau Bluetooth" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Connexion réseau Bluetooth" dhcp

//Reseau local
netsh interface IPv4 set dnsserver "Local Area Connection" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Local Area Connection" dhcp

//WIFI
netsh interface IPv4 set dnsserver "Wi-Fi" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Wi-Fi" dhcp
netsh interface IPv4 set dnsserver "Wi-Fi 1" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Wi-Fi 1" dhcp
netsh interface IPv4 set dnsserver "Wi-Fi 2" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Wi-Fi 2" dhcp
netsh interface IPv4 set dnsserver "Wi-Fi 3" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Wi-Fi 3" dhcp
netsh interface IPv4 set dnsserver "Wi-Fi 4" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Wi-Fi 4" dhcp

//Connection ethernet
netsh interface IPv4 set dnsserver "Ethernet" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet" dhcp
netsh interface IPv4 set dnsserver "Ethernet 1" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 1" dhcp
netsh interface IPv4 set dnsserver "Ethernet 2" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 2" dhcp
netsh interface IPv4 set dnsserver "Ethernet 3" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 3" dhcp
netsh interface IPv4 set dnsserver "Ethernet 4" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 4" dhcp
netsh interface IPv4 set dnsserver "Ethernet 5" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 5" dhcp
netsh interface IPv4 set dnsserver "Ethernet 6" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 6" dhcp
netsh interface IPv4 set dnsserver "Ethernet 7" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 7" dhcp
netsh interface IPv4 set dnsserver "Ethernet 8" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 8" dhcp
netsh interface IPv4 set dnsserver "Ethernet 9" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "Ethernet 9" dhcp

//Connection WMware
netsh interface IPv4 set dnsserver "VMware Network Adapter VMnet1" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "VMware Network Adapter VMnet1" dhcp
netsh interface IPv4 set dnsserver "VMware Network Adapter VMnet8" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "VMware Network Adapter VMnet8" dhcp

/Connection VPN
netsh interface IPv4 set dnsserver "VPN - VPN Client" static 0.0.0.0 both
netsh interface IPv4 set dnsserver "VPN - VPN Client" dhcp

//Restart All Connections
//ipconfig /flushdns
ipconfig /release
ipconfig /renew

//-Afficher les propriétés de la connexion sans fil Wi-Fi-
//netsh wlan show interfaces

//Connexion au réseau local* 1
//VMware Network Adapter VMnet1
//Connexion réseau Bluetooth
//Loopback Pseudo-Interface 1
//VirtualBox Host-Only Network
//VPN - VPN Client



//Pour désactiver la carte réseau :
//netsh interface set interface "Ethernet0" disable
//Pour activer la carte réseau :
//netsh interface set interface "Ethernet0" enable

//Pour désactiver l’IPV6
//netsh interface teredo set state disabled
//netsh interface ipv6 6to4 set state state=disabled undoonstop=disabled
//netsh interface ipv6 isatap set state state=disabled
//Pour réactiver l’IPV6 :
//netsh interface teredo set state enabled
//netsh interface ipv6 6to4 set state state=enabled undoonstop=enabled
//netsh interface ipv6 isatap set state state=enabled

//Réinitialiser pile TCP/IP et Winsock
//netsh winsock reset
//netsh winhttp reset tracing
//netsh winsock reset catalog
//netsh int ip reset all
//netsh int ipv4 reset catalog
//netsh int ipv6 reset catalog

//Afficher la configuration proxy
//netsh winhttp show proxy

//Configurer un proxy
//netsh winhttp set proxy 192.168.0.254:3128

//Supprimer un proxy
//netsh winhttp reset proxy


//ex:
//@echo off
//set carte="LAN"
//set adrfixe=192.168.0.22
//set masque=255.255.255.0
//set passerelle=192.168.0.1
//set dns1=1.1.1.1
//set dns2=1.0.0.1

//:question
//SET /P lan=Adressage IP 1/DCHP 2/FIXE 3/QUITTER (1/2/3)? :
//if %lan%==1 goto IPDHCP
//if %lan%==2 goto IPfixe
//if %lan%==3 goto Nfin
//goto question

//:IPfixe
//SET /P lan=confirmer l'adressage en IP Fixe 192.168.0.22 (O/N)? :
//if %lan%==o goto OKFixe
//if %lan%==O goto OKFixe
//if %lan%==n goto Nfin
//if %lan%==N goto Nfin
//goto IPfixe

//:OKFixe
//netsh interface ip set address %carte% static %adrfixe% %masque% %passerelle% 1
//netsh inter ip delete dns LAN all
//netsh inter ip set dns LAN static %dns1% primary
//netsh inter ip add dns LAN %dns2% index=2
//goto Ofin

//:IPDHCP
//SET /P lan=confirmer l'adressage en IP Dynamique (O/N)? :
//if %lan%==o goto OKDHCP
//if %lan%==O goto OKDHCP
//if %lan%==n goto Nfin
//if %lan%==N goto Nfin
//goto IPDHCP

//:OKDHCP
//netsh interface ip set address %carte% dhcp
//netsh inter ip delete dns LAN all
//netsh inter ip set dns LAN dhcp
//goto Ofin

//:Nfin
//@echo Aucune modification n'a ete appliquee
//@echo -
//SET /P lan=appuyez sur [ENTREE] pour quitter
//goto fin

//:Ofin
//@echo La nouvelle configuration vient d'etre appliquee
//@echo -
//SET /P lan=appuyer sur [ENTREE] pour quitter
//goto fin

//:fin

close
