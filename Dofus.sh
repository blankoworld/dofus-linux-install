#!/bin/bash
#@date : 2013-03-03
#@author : Ferora La Feu
#@version : 1
#@source : Mi-Black => http://forum.dofus.com/fr/1087-ergonomie-performances/1905980-tuto-installation-dofus-gnu-linux-transition-sdk-adobe-air

REP_INSTALL=$HOME/Ankama
REP_AIR=${REP_INSTALL}/airsdk
REP_DOFUS=${REP_INSTALL}/DofusLinux
REP_REG=${REP_DOFUS}/share/reg

URL_DDL_AIR=http://airdownload.adobe.com/air/lin/download/latest/AdobeAIRSDK.tbz2
NAME_DDL_AIR=AdobeAIRSDK.tbz2

URL_DDL_DOFUS=http://download.dofus.com/full/linux/
URL_DDL_DOFUS_64=${URL_DDL_DOFUS}x64
NAME_DDL_DOFUS=DofusInstall.tar.gz

echo "########################################"
echo "# Installation de Dofus sous GNU/Linux #"
echo "########################################"

#Répertoire d'installation
##S'il existe, on y va
if [ -d $REP_INSTALL ]; then
	cd $REP_INSTALL
##Sinon, on le crée avant d'y aller
else
	mkdir -p $REP_INSTALL
	cd $REP_INSTALL
fi

#Récupération d'AIR
echo ""
echo "Etape 1 : AIR sous GNU/Linux"
echo ""

##Si un répertoire existe déjà, on suppose qu'il est déjà installé, donc on passe directement à l'étape suivante.
if [ -d $REP_AIR ]; then
	echo "Un repertoire pour AIR existe deja. Son installation est donc ignoree."
##Sinon, on télécharge l'archive avant de la décompresser puis de la supprimer.
else
	echo "Recuperation et installation d'AIR."
	##Création du dossier pour AIR
	mkdir -p $REP_AIR
	##Déplacement dans le dossier d'AIR
	cd $REP_AIR
	##Récupération
	wget $URL_DDL_AIR
	##Décompression de l'archive
	tar -xjvf $NAME_DDL_AIR
	##Suppresion de l'archive devenue inutile
	rm $NAME_DDL_AIR
	##Retour au dossier d'installation
	cd $REP_INSTALL
fi

#Recuperation du script d'install d'Ankama
echo ""
echo "Etape 2 : Dofus sous GNU/LInux"
echo ""

##Si un répertoire existe déjà, on suppose que le jeu a déjà été récupéré et installé, donc on passe à l'étape suivante.
if [ -d $REP_DOFUS ]; then
	echo "Un repertoire pour Dofus sous GNU/Linux existe deja. Sa recuperation est donc ignoree."
##Sinon, on récupére le jeu avant de décompresser l'archive puis de la supprimer.
else
	##Récupération de l'archive pour Dofus selon le processeur
	BITS=$(uname -p)
	if [ "$1" = "32" ] || [ "$BITS" = "i386" ]; then
		wget $URL_DDL_DOFUS -O $NAME_DDL_DOFUS
	elif [ "$1" = "64" ] || [ "$BITS" = "x86_64" ]; then
		wget $URL_DDL_DOFUS_64 -O $NAME_DDL_DOFUS
	else
		echo "Je n'arrive pas a determiner seul le type de votre processeur, veuillez le préciser : 32 ou 64."
		read PROC
		if [ "$PROC" = "32" ]; then
			wget $URL_DDL_DOFUS -O $NAME_DDL_DOFUS
		elif [ "$PROC" = "64" ]; then
			wget $URL_DDL_DOFUS_64 -O $NAME_DDL_DOFUS
		else
			echo "Vous n'avez marque ni 32, ni 64. Je ne peux continuer sans cette information."
			echo "Vous pouvez aussi preciser 32 ou 64 en argument de ce script."
			exit 0;
		fi
	fi

	##Decompression de l'archive
	tar -xvf ./$NAME_DDL_DOFUS
	##Suppresion de l'archive devenue inutile
	rm $NAME_DDL_DOFUS
	##Renomme le dossier pour bien signaler qu'il s'agit du Dofus pour GNU/Linux
	mv Dofus $REP_DOFUS
fi

#Ajout des commandes nécessaires pour préciser l'emplacement d'AIR
echo ""
echo "Etape 3 : Corrections pour preciser a Dofus ou est AIR"
echo ""

##Ajout d'un script pour lancer correctement REG sous GNU/Linux (pour avoir le son) avec AIR
echo "#!/bin/sh
${REP_AIR}/bin/adl ${REP_DOFUS}/share/reg/share/META-INF/AIR/application.xml ${REP_DOFUS}/share/reg/share -- \$@" > $REP_DOFUS/launch_reg.sh
##Donne la permission au script d'être exécuté par l'utilisateur courant
chmod u+x $REP_DOFUS/launch_reg.sh

##Ajout des commandes à transition.conf pour lui signaler où est AIR
echo "bypass_air_installation = true
launcher.command = \"${REP_AIR}/bin/adl ${REP_DOFUS}/share/META-INF/AIR/application.xml ${REP_DOFUS}/share -- \"

dofus.reg.path = \"${REP_DOFUS}/launch_reg.sh\"" >> $REP_DOFUS/transition.conf

#Création des raccourci pour le bureau et le menu d'applications
echo ""
echo "Etape 4 : Creation des raccourcis"
echo ""

if [ -f $HOME/Bureau/DofusLinuxUpdater.desktop ] || [ -f $HOME/Desktop/DofusLinuxUpdater.desktop ]; then
	echo "Un raccourci existe deja. Sa creation est ignoree."
else
	if [ -d $HOME/Bureau ]; then
		echo "[Desktop Entry]
		Encoding=UTF-8
		Type=Application
		Name="Dofus Linux Updater"
		Icon="$REP_DOFUS/share/icon/dofus-icon-48.png"
		Exec="$REP_DOFUS/Dofus"
		Path="$REP_DOFUS/"
		Categories=Game" > $HOME/Bureau/DofusLinuxUpdater.desktop
		##Donne la permission au script d'être exécuté par l'utilisateur courant
		chmod u+x $HOME/Bureau/DofusLinuxUpdater.desktop
		##Copie le raccourci pour le menu d'applications
		cp $HOME/Bureau/DofusLinuxUpdater.desktop $HOME/.local/share/applications/DofusLinuxUpdater.desktop
	elif [ -d $HOME/Desktop ]; then
		echo "[Desktop Entry]
		Encoding=UTF-8
		Type=Application
		Name="Dofus Linux Updater"
		Icon="$REP_DOFUS/share/icon/dofus-icon-48.png"
		Exec="$REP_DOFUS/Dofus"
		Path="$REP_DOFUS/"
		Categories=Game" > $HOME/Desktop/DofusLinuxUpdater.desktop
		##Donne la permission au script d'être exécuté par l'utilisateur courant
		chmod u+x $HOME/Desktop/DofusLinuxUpdater.desktop
		##Copie le raccourci pour le menu d'applications
		cp $HOME/Desktop/DofusLinuxUpdater.desktop $HOME/.local/share/applications/DofusLinuxUpdater.desktop
	else
		echo "Heu... Je ne sais pas ou est le bureau. Je ne peux donc cree le raccourci. Desole."
	fi
fi

#Lancement de l'upLauncher pour les mises a jour puis pour jouer
echo ""
echo "Etape finale : Lancement de l'updater ..."
echo ""

$REP_DOFUS/Dofus 2> /dev/null

exit 0;