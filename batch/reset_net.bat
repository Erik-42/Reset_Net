@echo off
setlocal EnableDelayedExpansion

:: --- Mode Simulation ---
set "MODE_SIMULATION=0"
set "SIMULATION_PREFIX=[SIMULATION] "

:: --- Mode Debug ---
set "DEBUG_MODE=0"
set "DEBUG_PREFIX=[DEBUG] "

:: --- Fonction pour gérer le mode simulation ---
:checkSimulation
if "%1"=="--simulation" (
    set "MODE_SIMULATION=1"
    echo %SIMULATION_PREFIX%Mode simulation activé - Aucune modification ne sera appliquée
    echo.
)

:: --- Fonction pour gérer le mode debug ---
:checkDebug
if "%1"=="--debug" (
    set "DEBUG_MODE=1"
    echo %DEBUG_PREFIX%Mode debug activé
    echo.
)

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


:: --- Affichage de la configuration réseau actuelle ---
:infoNetworkUser
echo ========================================
echo =       Reset_Net par Erik-42          =
echo =       reset computer network         =
echo = https://github.com/Erik-42/reset_net =
echo ========================================
echo.
echo Configuration réseau actuelle:
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "Carte"') do echo Carte: %%a
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "IPv4"') do echo IP: %%a
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "Masque"') do echo Masque: %%a
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "Passerelle"') do echo Passerelle: %%a
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "DNS"') do echo DNS: %%a
echo.

echo Que souhaitez-vous faire ?
echo 1. Afficher le menu principal
echo 2. Exporter la configuration actuelle dans un rapport
choice /C 12 /N /M "Votre choix (1 ou 2) : "

if errorlevel 2 (
    goto generateQuickReport
) else (
    goto mainMenu
)

:: --- Générer un rapport rapide de la configuration actuelle ---
:generateQuickReport
call :debugMsg "Génération du rapport rapide"
set "desktop=%USERPROFILE%\Desktop"
set "timestamp=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "timestamp=%timestamp: =0%"
set "reportFile=%desktop%\config_reseau_%timestamp%.txt"

if "%MODE_SIMULATION%"=="1" (
    echo %SIMULATION_PREFIX%Simulation de génération du rapport rapide
    echo %SIMULATION_PREFIX%Le rapport serait créé ici: %reportFile%
) else (
    echo Génération du rapport en cours...
    echo ===== CONFIGURATION RESEAU ACTUELLE ===== > "%reportFile%"
    echo Date et heure: %date% %time% >> "%reportFile%"
    echo. >> "%reportFile%"
    ipconfig /all >> "%reportFile%"
    echo Rapport généré avec succès: %reportFile%
)

echo.
echo Appuyez sur une touche pour continuer vers le menu principal...
pause >nul
goto mainMenu

:: --- Menus ---
:mainMenu
call :debugMsg "Entrée dans le menu principal"
if "%MODE_SIMULATION%"=="1" echo %SIMULATION_PREFIX%
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
echo 96. Générer un rapport réseau complet
echo 97. Activer/Désactiver mode debug
echo 98. Activer/Désactiver mode simulation
echo 99. Quitter
SET /P choix="Votre choix : "
call :debugMsg "Option choisie: %choix%"

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
if "%choix%"=="96" goto generateReport
if "%choix%"=="97" goto toggleDebug
if "%choix%"=="98" goto toggleSimulation
if "%choix%"=="99" goto fin
goto mainMenu

:cardMenu
cls
call :debugMsg "Entrée dans le menu de sélection des cartes"
echo Quelle carte voulez-vous configurer ?
echo ================================
for /f "skip=3 tokens=1,2,*" %%i in ('netsh interface show interface') do (
    echo %%i %%j %%k
    call :debugMsg "Carte trouvée: %%i %%j %%k"
)
echo.
SET /P carteChoisie="Entrez le nom exact de la carte : "
call :debugMsg "Carte sélectionnée: %carteChoisie%"
set "carte=!carteChoisie!"
goto mainMenu

:: --- Fonctions ---

:: --- Remettre à zéro toutes les connexions ---
:ResetNet
call :debugMsg "Début de la réinitialisation réseau"
if "%MODE_SIMULATION%"=="1" (
    echo %SIMULATION_PREFIX%Simulation de réinitialisation réseau:
    echo %SIMULATION_PREFIX%- Flush DNS
    echo %SIMULATION_PREFIX%- Reset TCP/IP
    echo %SIMULATION_PREFIX%- Release IP
    echo %SIMULATION_PREFIX%- Renew IP
) else (
    call :debugMsg "Exécution de ipconfig /flushdns"
    ipconfig /flushdns
    call :debugMsg "Exécution de netsh int ip reset"
    netsh int ip reset ..\tcpipreset.txt
    call :debugMsg "Exécution de ipconfig /release"
    ipconfig /release
    call :debugMsg "Exécution de ipconfig /renew"
    ipconfig /renew
)
call :debugMsg "Fin de la réinitialisation réseau"
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
call :debugMsg "Configuration DHCP demandée pour la carte %carte%"
if "%MODE_SIMULATION%"=="1" (
    echo %SIMULATION_PREFIX%Simulation passage en DHCP:
    echo %SIMULATION_PREFIX%- Configuration DHCP sur %carte%
    echo %SIMULATION_PREFIX%- Suppression DNS
    echo %SIMULATION_PREFIX%- Configuration DNS automatique
) else (
    call :debugMsg "Configuration de l'adresse IP en DHCP"
    netsh interface ip set address "%carte%" dhcp
    call :debugMsg "Suppression des DNS existants"
    netsh interface ipv4 delete dns "%carte%" all
    call :debugMsg "Configuration des DNS en DHCP"
    netsh interface ipv4 set dns "%carte%" dhcp
)
call :debugMsg "Configuration DHCP terminée"
echo Configuration DHCP appliquee.
goto mainMenu

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
goto mainMenu


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
goto mainMenu

:IPMask
cls
call :debugMsg "Configuration du masque réseau"
echo Configuration du masque réseau
SET /P nouveauMasque="Entrez le nouveau masque réseau (ex: 255.255.255.0) : "
call :debugMsg "Nouveau masque saisi: %nouveauMasque%"

if "%MODE_SIMULATION%"=="1" (
    echo %SIMULATION_PREFIX%Simulation changement de masque:
    echo %SIMULATION_PREFIX%- Carte: %carte%
    echo %SIMULATION_PREFIX%- Nouveau masque: %nouveauMasque%
) else (
    call :debugMsg "Application du nouveau masque sur la carte %carte%"
    netsh interface ipv4 set address name="%carte%" source=static mask=%nouveauMasque%
    call :debugMsg "Masque appliqué avec succès"
)
echo Configuration du masque appliquée.
timeout /t 3
goto mainMenu

:IPDNSIPV4
cls
echo Configuration des DNS IPv4
SET /P nouveauDNS1="Entrez le DNS primaire : "
SET /P nouveauDNS2="Entrez le DNS secondaire : "
netsh interface ipv4 delete dns "%carte%" all
netsh interface ipv4 set dns "%carte%" static %nouveauDNS1% primary
netsh interface ipv4 add dns "%carte%" %nouveauDNS2% index=2
echo Configuration DNS appliquée.
timeout /t 3
goto mainMenu

:IPfixeIPV6
cls
echo Configuration des DNS IPv6
SET /P nouveauDNS1="Entrez le DNS primaire IPv6 : "
SET /P nouveauDNS2="Entrez le DNS secondaire IPv6 : "
netsh interface ipv6 delete dns "%carte%" all
netsh interface ipv6 set dns "%carte%" static %nouveauDNS1% primary
netsh interface ipv6 add dns "%carte%" %nouveauDNS2% index=2
echo Configuration DNS IPv6 appliquée.
timeout /t 3
goto mainMenu

:: --- Toggle Simulation Mode ---
:toggleSimulation
if "%MODE_SIMULATION%"=="1" (
    set "MODE_SIMULATION=0"
    echo Mode simulation désactivé
) else (
    set "MODE_SIMULATION=1"
    echo %SIMULATION_PREFIX%Mode simulation activé
)
timeout /t 2
goto mainMenu

:: --- Toggle Debug Mode ---
:toggleDebug
if "%DEBUG_MODE%"=="1" (
    set "DEBUG_MODE=0"
    echo Mode debug désactivé
) else (
    set "DEBUG_MODE=1"
    echo %DEBUG_PREFIX%Mode debug activé
)
timeout /t 2
goto mainMenu

:fin
echo Aucune modification n'a ete appliquee.
echo Appuyez sur [ENTREE] pour quitter.
pause
exit

:: --- Fonction pour afficher les messages de debug ---
:debugMsg
if "%DEBUG_MODE%"=="1" (
    echo %DEBUG_PREFIX%%~1
)
goto :eof

:: --- Générer un rapport réseau complet ---
:generateReport
call :debugMsg "Génération du rapport réseau"
set "desktop=%USERPROFILE%\Desktop"
set "timestamp=%date:~6,4%-%date:~3,2%-%date:~0,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%"
set "timestamp=%timestamp: =0%"
set "reportFile=%desktop%\rapport_reseau_%timestamp%.txt"

if "%MODE_SIMULATION%"=="1" (
    echo %SIMULATION_PREFIX%Simulation de génération du rapport réseau
    echo %SIMULATION_PREFIX%Le rapport serait créé ici: %reportFile%
) else (
    echo Génération du rapport réseau en cours...
    echo ===== RAPPORT RESEAU RESET_NET ===== > "%reportFile%"
    echo Date et heure: %date% %time% >> "%reportFile%"
    echo. >> "%reportFile%"
    
    echo === CONFIGURATION IP === >> "%reportFile%"
    ipconfig /all >> "%reportFile%"
    echo. >> "%reportFile%"
    
    echo === ROUTES === >> "%reportFile%"
    route print >> "%reportFile%"
    echo. >> "%reportFile%"
    
    echo === DNS CACHE === >> "%reportFile%"
    ipconfig /displaydns >> "%reportFile%"
    echo. >> "%reportFile%"
    
    echo === STATISTIQUES RESEAU === >> "%reportFile%"
    netstat -e >> "%reportFile%"
    echo. >> "%reportFile%"
    
    echo === TEST DE CONNECTIVITE === >> "%reportFile%"
    ping 8.8.8.8 -n 4 >> "%reportFile%"
    ping www.google.com -n 4 >> "%reportFile%"
    
    echo Rapport généré avec succès: %reportFile%
)

timeout /t 3
goto mainMenu
