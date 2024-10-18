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

@echo off

:: --- Paramètres réseau par défaut ---
set "adrfixe=192.168.0.2"
set "masque=255.255.255.0"
set "passerelle=192.168.0.1"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS

:: --- Détection automatique de l'adresse IP ---
for /f "tokens=3" %%I in ('netsh interface ip show address ^| find "Adresse IP"') do set adrfixe=%%I
echo Adresse IP détectée automatiquement: %adrfixe%
SET /P confIP="Est-ce la bonne adresse IP (O/N)? : "
if /I "%confIP%"=="N" (
    SET /P adrfixe="Veuillez entrer l'adresse IP manuellement : "
)

:: --- Détection automatique de la passerelle ---
for /f "tokens=3" %%G in ('netsh interface ip show config %carte% ^| find "Passerelle par defaut"') do set passerelle=%%G
echo Passerelle détectée automatiquement: %passerelle%
SET /P confPasserelle="Est-ce la bonne passerelle (O/N)? : "
if /I "%confPasserelle%"=="N" (
    SET /P passerelle="Veuillez entrer la passerelle manuellement : "
)

:menu
:: --- Menu pour choisir entre DHCP ou IP Fixe ---
echo Adressage IP:
echo 1. DHCP
echo 2. Fixe (Statique)
echo 3. Quitter
SET /P choix="Votre choix (1/2/3): "

if "%choix%"=="1" goto IPDHCP
if "%choix%"=="2" goto IPfixe
if "%choix%"=="3" goto fin
goto menu

:IPfixe
:: --- Appliquer la configuration IP Fixe et DNS ---
netsh interface ip set address "%carte%" static %adrfixe% %masque% %passerelle% 1
if %ERRORLEVEL%==0 (
    echo IP statique configurée avec succès sur %carte%.
) else (
    echo Erreur lors de la configuration de l'IP sur %carte%.
)
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" static %dns1% primary
netsh interface ipv4 add dns "%carte%" %dns2% index=2
if %ERRORLEVEL%==0 (
    echo DNS configurés avec succès sur %carte%.
) else (
    echo Erreur lors de la configuration des DNS sur %carte%.
)
goto fin

@echo off

:: --- Set Network Configuration Variables ---
set "carte=LAN"
set "adrfixe=192.168.0.22"
set "masque=255.255.255.0"
set "passerelle=192.168.0.1"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS

:menu
:: --- Main Menu for IP Configuration Options ---
echo Adressage IP:
echo 1. DHCP
echo 2. Fixe (Statique)
echo 3. Quitter
SET /P choix="Votre choix (1/2/3): "

if "%choix%"=="1" goto IPDHCP
if "%choix%"=="2" goto IPfixe
if "%choix%"=="3" goto fin
goto menu

:IPfixe
:: --- Confirmation for Static IP ---
SET /P confIPfixe="Confirmer l'adressage en IP Fixe (%adrfixe%) (O/N)? : "
if /I "%confIPfixe%"=="O" goto OKFixe
if /I "%confIPfixe%"=="N" goto fin
goto IPfixe

:OKFixe
:: --- Apply Static IP Address and DNS Configuration ---
netsh interface ip set address "%carte%" static %adrfixe% %masque% %passerelle% 1
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" static %dns1% primary
netsh interface ipv4 add dns "%carte%" %dns2% index=2
echo Configuration IP Fixe appliquee.
goto fin

:IPDHCP
:: --- Confirmation for DHCP ---
SET /P confDHCP="Confirmer l'adressage en IP Dynamique (O/N)? : "
if /I "%confDHCP%"=="O" goto OKDHCP
if /I "%confDHCP%"=="N" goto fin
goto IPDHCP

:OKDHCP
:: --- Apply DHCP Configuration ---
netsh interface ip set address "%carte%" dhcp
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" dhcp
echo Configuration DHCP appliquee.
goto fin

:fin
echo Aucune modification n'a ete appliquee.
echo Appuyez sur [ENTREE] pour quitter.
pause
exit


@echo off

:: --- Set Network Configuration Variables ---
set "carte=LAN"
set "adrfixe=192.168.0.22"
set "masque=255.255.255.0"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS

:: --- Trouver la passerelle automatiquement ---
for /f "tokens=3" %%G in ('netsh interface ip show config %carte% ^| find "Passerelle par defaut"') do set passerelle=%%G

:: --- Confirmer la passerelle détectée ---
echo Passerelle détectée automatiquement: %passerelle%
SET /P confPasserelle="Est-ce la bonne adresse de passerelle (O/N)? : "

if /I "%confPasserelle%"=="N" (
    SET /P passerelle="Veuillez entrer l'adresse de passerelle manuellement : "
)

:menu
:: --- Menu pour choisir entre DHCP ou IP Fixe ---
echo Adressage IP:
echo 1. DHCP
echo 2. Fixe (Statique)
echo 3. Quitter
SET /P choix="Votre choix (1/2/3): "

if "%choix%"=="1" goto IPDHCP
if "%choix%"=="2" goto IPfixe
if "%choix%"=="3" goto fin
goto menu

:IPfixe
:: --- Confirmation de l'adressage IP Fixe ---
SET /P confIPfixe="Confirmer l'adressage en IP Fixe (%adrfixe%) (O/N)? : "
if /I "%confIPfixe%"=="O" goto OKFixe
if /I "%confIPfixe%"=="N" goto fin
goto IPfixe

:OKFixe
:: --- Appliquer la configuration IP Fixe et DNS ---
netsh interface ip set address "%carte%" static %adrfixe% %masque% %passerelle% 1
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" static %dns1% primary
netsh interface ipv4 add dns "%carte%" %dns2% index=2
echo Configuration IP Fixe appliquee.
goto fin

:IPDHCP
:: --- Appliquer la configuration DHCP ---
netsh interface ip set address "%carte%" dhcp
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" dhcp
echo Configuration DHCP appliquee.
goto fin

:fin
echo Aucune modification n'a ete appliquee.
echo Appuyez sur [ENTREE] pour quitter.
pause
exit


@echo off

:: --- Trouver l'adresse IP de la machine automatiquement ---
for /f "tokens=3" %%I in ('netsh interface ip show address ^| find "Adresse IP"') do set adrfixe=%%I

:: --- Confirmer l'adresse IP détectée ---
echo Adresse IP détectée automatiquement: %adrfixe%
SET /P confIP="Est-ce la bonne adresse IP (O/N)? : "

if /I "%confIP%"=="N" (
    SET /P adrfixe="Veuillez entrer l'adresse IP manuellement : "
)

:: --- Set Other Network Configuration Variables ---
set "carte=LAN"
set "masque=255.255.255.0"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS

:: --- Trouver la passerelle automatiquement ---
for /f "tokens=3" %%G in ('netsh interface ip show config %carte% ^| find "Passerelle par defaut"') do set passerelle=%%G

:: --- Confirmer la passerelle détectée ---
echo Passerelle détectée automatiquement: %passerelle%
SET /P confPasserelle="Est-ce la bonne adresse de passerelle (O/N)? : "

if /I "%confPasserelle%"=="N" (
    SET /P passerelle="Veuillez entrer l'adresse de passerelle manuellement : "
)

:menu
:: --- Menu pour choisir entre DHCP ou IP Fixe ---
echo Adressage IP:
echo 1. DHCP
echo 2. Fixe (Statique)
echo 3. Quitter
SET /P choix="Votre choix (1/2/3): "

if "%choix%"=="1" goto IPDHCP
if "%choix%"=="2" goto IPfixe
if "%choix%"=="3" goto fin
goto menu

:IPfixe
:: --- Appliquer la configuration IP Fixe et DNS ---
netsh interface ip set address "%carte%" static %adrfixe% %masque% %passerelle% 1
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" static %dns1% primary
netsh interface ipv4 add dns "%carte%" %dns2% index=2
echo Configuration IP Fixe appliquee.
goto fin

:IPDHCP
:: --- Appliquer la configuration DHCP ---
netsh interface ip set address "%carte%" dhcp
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" dhcp
echo Configuration DHCP appliquee.
goto fin

:fin
echo Aucune modification n'a ete appliquee.
echo Appuyez sur [ENTREE] pour quitter.
pause
exit


@echo off

:: --- Paramètres réseau que vous souhaitez configurer sur toutes les cartes réseaux ---
set "adrfixe=192.168.0.22"
set "masque=255.255.255.0"
set "passerelle=192.168.0.1"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS

:: --- Lister toutes les cartes réseaux disponibles ---
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface ^| find "Connecté"') do (
    set "carte=%%I"
    :: Supprimer les espaces au début et à la fin
    set "carte=!carte:~1!"
    
    :: --- Appliquer les paramètres sur chaque carte réseau ---
    echo Configuration de la carte réseau: !carte!
    
    :: Configuration de l'adresse IP statique, masque, et passerelle
    netsh interface ip set address name="!carte!" static %adrfixe% %masque% %passerelle% 1
    
    :: Configuration des serveurs DNS
    netsh interface ipv4 delete dns name="!carte!" all
    netsh interface ipv4 set dns name="!carte!" static %dns1% primary
    netsh interface ipv4 add dns name="!carte!" %dns2% index=2
)

echo Toutes les cartes réseaux ont été configurées avec succès.
pause
exit


@echo off

:: --- Liste prédéfinie de serveurs DNS ---
echo Choisissez votre DNS préféré :
echo 1. CloudFlare (1.1.1.1, 1.0.0.1)
echo 2. Google (8.8.8.8, 8.8.4.4)
echo 3. OpenDNS (208.67.222.222, 208.67.220.220)
SET /P dnschoix="Votre choix (1/2/3) : "

:: --- Configurer les DNS selon le choix ---
if "%dnschoix%"=="1" (
    set "dns1=1.1.1.1"
    set "dns2=1.0.0.1"
    echo CloudFlare DNS sélectionné.
)
if "%dnschoix%"=="2" (
    set "dns1=8.8.8.8"
    set "dns2=8.8.4.4"
    echo Google DNS sélectionné.
)
if "%dnschoix%"=="3" (
    set "dns1=208.67.222.222"
    set "dns2=208.67.220.220"
    echo OpenDNS sélectionné.
)

:: --- Paramètres réseau à configurer sur toutes les cartes ---
set "adrfixe=192.168.0.22"
set "masque=255.255.255.0"
set "passerelle=192.168.0.1"

:: --- Lister et configurer toutes les cartes réseaux détectées ---
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface ^| find "Connecté"') do (
    set "carte=%%I"
    :: Supprimer les espaces au début et à la fin
    set "carte=!carte:~1!"
    
    :: Appliquer la configuration IP et DNS
    echo Configuration de la carte réseau: !carte!
    netsh interface ip set address name="!carte!" static %adrfixe% %masque% %passerelle% 1
    netsh interface ipv4 delete dns name="!carte!" all
    netsh interface ipv4 set dns name="!carte!" static %dns1% primary
    netsh interface ipv4 add dns name="!carte!" %dns2% index=2
)

echo Configuration terminée pour toutes les cartes réseaux.
pause
exit


@echo off

:: --- Paramètres réseau à configurer sur toutes les cartes ---
set "adrfixe=192.168.0.22"
set "dns1=1.1.1.1"         :: CloudFlare Primary DNS
set "dns2=1.0.0.1"         :: CloudFlare Secondary DNS
set "passerelle=192.168.0.1"

:: --- Détecter automatiquement le masque de sous-réseau ---
for /f "tokens=3" %%M in ('netsh interface ip show config ^| find "Masque de sous-reseau"') do set "masque=%%M"

:: --- Demander confirmation du masque de sous-réseau détecté ---
echo Masque de sous-réseau détecté: %masque%
SET /P confMasque="Est-ce le bon masque de sous-réseau (O/N)? : "

if /I "%confMasque%"=="N" (
    SET /P masque="Veuillez entrer manuellement le masque de sous-réseau : "
)

:: --- Lister et configurer toutes les cartes réseaux détectées ---
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface ^| find "Connecté"') do (
    set "carte=%%I"
    :: Supprimer les espaces au début et à la fin
    set "carte=!carte:~1!"
    
    :: Appliquer la configuration IP et DNS
    echo Configuration de la carte réseau: !carte!
    netsh interface ip set address name="!carte!" static %adrfixe% %masque% %passerelle% 1
    netsh interface ipv4 delete dns name="!carte!" all
    netsh interface ipv4 set dns name="!carte!" static %dns1% primary
    netsh interface ipv4 add dns name="!carte!" %dns2% index=2
)

echo Configuration terminée pour toutes les cartes réseaux.
pause
exit


:IPDHCP
:: --- Appliquer la configuration DHCP ---
netsh interface ip set address "%carte%" dhcp
if %ERRORLEVEL%==0 (
    echo Configuration DHCP appliquée avec succès sur %carte%.
) else (
    echo Erreur lors de la configuration DHCP sur %carte%.
)
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" dhcp
if %ERRORLEVEL%==0 (
    echo DNS DHCP configurés avec succès sur %carte%.
) else (
    echo Erreur lors de la configuration des DNS DHCP sur %carte%.
)
goto fin

:: --- Configuration pour toutes les cartes réseaux détectées ---
for /f "tokens=2 delims=:" %%I in ('netsh interface show interface ^| find "Connecté"') do (
    set "carte=%%I"
    set "carte=!carte:~1!"
    
    echo Configuration de la carte réseau: !carte!
    
    :: Appliquer l'IP statique, masque et passerelle
    netsh interface ip set address name="!carte!" static %adrfixe% %masque% %passerelle% 1
    if %ERRORLEVEL%==0 (
        echo IP statique configurée avec succès sur !carte!.
    ) else (
        echo Erreur lors de la configuration de l'IP sur !carte!.
    )
    
    :: Appliquer les DNS
    netsh interface ipv4 delete dns name="!carte!" all
    netsh interface ipv4 set dns name="!carte!" static %dns1% primary
    netsh interface ipv4 add dns name="!carte!" %dns2% index=2
    if %ERRORLEVEL%==0 (
        echo DNS configurés avec succès sur !carte!.
    ) else (
        echo Erreur lors de la configuration des DNS sur !carte!.
    )
)

:fin
echo Configuration terminée pour toutes les cartes réseaux.
pause
exit
