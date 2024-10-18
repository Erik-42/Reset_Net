@echo off

:: --- Exemple Configuration par défaut ---
:: --- set "carte=LAN" ---
:: --- set "adrfixe=192.168.0.2" ---
:: --- set "masque=255.255.255.0" ---
:: --- set "passerelle=192.168.0.1" ---
:: --- set "dns1=1.1.1.1"  CloudFlare Primary DNS ---
:: --- set "dns2=1.0.0.1"  CloudFlare Secondary DNS ---
:: ---  ---


:: --- Congiguration installé par défaut ---
:defaultConfig
set "carte=LAN"
set "adrfixe=192.168.0.2"
set "masque=255.255.255.0"
set "passerelle=192.168.0.1"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS


:: --- Congiguration actuelle utilisateur ---
:infoNetworkUser
echo votre configuration réseau actuelle:
echo Carte: carte réseaux
echo IP: xxx.xxx.xxx.xxx. (IP DHCP ou Fixe)
echo Masque: xxx.xxx.xxx.xxx.
echo Passerelle: xxx.xxx.xxx.xxx
echo DNS primaire: xxx.xxx.xxx.xxx
echo Dns secondaire: xxx.xxx.xxx.xxx


:: --- Menus ---
:mainMenu
echo que souhaitez-vous faire ?
echo Adressage IP:
echo 0. Reset All Network
echo 1. Passer en IP DHCP
echo 2. Passer en IP Fixe IPV4 (Statique)
echo 3. Modifier IP de la passerelle
echo 4. Modifier le Masque réseau
echo 5. Désactiver les cartes réseaux
echo 6. Effacer les IP DNS
echo 7. Modifier les IP DNS IPV4
echo 8. Passer en IP Fixe IPV6 (Statique)
echo 9. Modifier les IP DNS IPV6
echo 99. Quitter
SET /P choix="Votre choix (1/2/3/4/5/6/7/8/9/99): "

if "%choix%"=="0" goto ResetNet
if "%choix%"=="1" goto IPDHCP
if "%choix%"=="2" goto IPfixeIPV4
if "%choix%"=="3" goto IPGateway
if "%choix%"=="4" goto IPMask
if "%choix%"=="5" goto IPDNSIPV4
if "%choix%"=="6" goto OffNet
if "%choix%"=="7" goto OffDNS
if "%choix%"=="8" goto IPfixeIPV6
if "%choix%"=="9" goto IPDNSIPV6
if "%choix%"=="99" goto fin
goto mainMenu

:cardMenu
echo quelle carte voulez vous désactiver
echo 0. All Card
echo 1. Card 1
echo 1. Card 2
echo 1. Card 3
echo 1. Card 4

if "%choix%"=="0" goto ResetNet
if "%choix%"=="1" goto ResetNet
goto mainMenu

:: --- Fonctions ---

:: --- Remettre à zéro toutes les connexions ---
:ResetNet
ipconfig /flushdns
netsh int ip reset ..\tcpipreset.txt
ipconfig /release
ipconfig /renew
goto mainMenu

:: --- Pour désactiver les cartes réseaux : ---
:OffNet
netsh interface set interface "Ethernet0" disable
:: --- Pour activer la carte réseau :---
netsh interface set interface "Ethernet0" enable
goto menu

:: --- supprimer les DNS : ---
:OffDNS
netsh inter ipv4 delete dns LAN all
netsh inter ipv6 delete dns LAN all
goto menu


:: --- Appliquer la configuration DHCP ou IP Fixe ---
:: --- Appliquer la configuration DHCP IPV4 ---

:IPDHCP
netsh interface ip set address "%carte%" dhcp
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" dhcp
echo Configuration DHCP appliquee.
goto menu

:IPfixeIPV4
:: --- Confirmation de l'adressage IP Fixe IPV4 ---
SET /P confIPfixe="Confirmer l'adressage en IP Fixe (%adrfixe%) (O/N)? : "
if /I "%confIPfixe%"=="O" goto OKFixeIPV4
if /I "%confIPfixe%"=="N" goto fin

:OKFixeIPV4
netsh interface ip set address "%carte%" static %adrfixe% %masque% %passerelle% 1
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" static %dns1% primary
netsh interface ipv4 add dns "%carte%" %dns2% index=2
echo Configuration IP Fixe appliquee.
goto menu


:IPGateway
:: --- Trouver la passerelle automatiquement ---
for /f "tokens=3" %%G in ('netsh interface ip show config %carte% ^| find "Passerelle par defaut"') do set passerelle=%%G

:: --- Confirmer la passerelle détectée ---
echo Passerelle détectée automatiquement: %passerelle%
SET /P confPasserelle="Est-ce la bonne adresse de passerelle (O/N)? : "

if /I "%confPasserelle%"=="N" (
    SET /P passerelle="Veuillez entrer l'adresse de passerelle manuellement : "
)

echo Configuration Gateway appliquee.
goto menu

:IPMask

echo Configuration Mask appliquee.
goto menu

:IPDNS

echo Configuration DNS appliquee.
goto menu

:fin
echo Aucune modification n'a ete appliquee.
echo Appuyez sur [ENTREE] pour quitter.
pause
exit
