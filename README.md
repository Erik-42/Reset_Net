# Reset_Net
Batch de manipulation des connexions réseaux

Script de réinitialisation du réseau par Erik-42

[![wakatime](https://wakatime.com/badge/github/Erik-42/reset_net.svg)](https://wakatime.com/badge/github/Erik-42/reset_net)

[![wakatime](https://wakatime.com/badge/user/f84d00d8-fee3-4ca3-803d-3daa3c7053a5/project/ead645fe-29fa-48bf-90a7-470e1baddf18.svg)](https://wakatime.com/badge/user/f84d00d8-fee3-4ca3-803d-3daa3c7053a5/project/ead645fe-29fa-48bf-90a7-470e1baddf18)


Voici une version optimisée de votre script avec des messages de succès ou d'échec pour chaque opération clé (configuration de l'adresse IP, de la passerelle, et des DNS).

Optimisations ajoutées :
Messages de réussite ou d'échec : Chaque action réseau (configuration d'IP, de passerelle, et de DNS) est suivie d'un message indiquant si l'opération a réussi ou échoué. Cela est contrôlé par %ERRORLEVEL% qui vérifie si la dernière commande a été exécutée avec succès.
Simplification et clarté : Les messages sont clairs et adaptés à chaque étape du script pour faciliter le débogage en cas de problème.
Boucle pour toutes les interfaces : Toutes les cartes réseau connectées sont détectées, et les paramètres réseau sont appliqués automatiquement.
Ce script permet de configurer plusieurs cartes réseaux tout en vérifiant le bon déroulement des opérations.