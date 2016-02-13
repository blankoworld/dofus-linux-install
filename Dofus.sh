#!/bin/bash

REP_INSTALL=$HOME/Dofus_Script
REP_AIR=${REP_INSTALL}/airsdk
REP_DOFUS=${REP_INSTALL}/Dofus
REP_REG=${REP_DOFUS}/share/reg


#Récupération de AIR
mkdir -p $REP_AIR 2> /dev/null ; cd $REP_AIR
wget http://airdownload.adobe.com/air/lin/download/latest/AdobeAIRSDK.tbz2
tar -xjvf AdobeAIRSDK.tbz2

#Recuperation du script d'install d'Ankama
mkdir $REP_DOFUS
cd $REP_DOFUS
wget http://download.dofus.com/full/linux/x64 -O Dofus-amd64.tar.gz
tar -xvf Dofus-amd64.tar.gz -C $REP_AIR

#Creation de l'arborescence
#mkdir -p $REP_DOFUS/share/reg/bin
#mkdir -p $REP_DOFUS/share/reg/share
mkdir $REP_DOFUS/bin

#Decompression des fichiers contenus dans l'install
#./DofusInstall.run --target $REP_DOFUS/share --noexec

#Install de Dofus
#cd $REP_DOFUS/share
#cp -r $REP_DOFUS/share/Dofus/share/* $REP_DOFUS/share
#rm -rf $REP_DOFUS/share/Dofus

#Install de reg pour le son
#rm -rf $REP_DOFUS/share/reg
#mv $REP_DOFUS/share/Reg $REP_DOFUS/share/reg
#mv $REP_REG/share/Reg.swf $REP_REG
#ln -s ../content $REP_REG/share/content
#ln -s ../config.xml $REP_REG/share/config.xml
#ln -s ../Reg.swf $REP_REG/share/Reg.swf

#Creation des raccourcis necessaires a l'uplauncher
echo "${REP_AIR}/bin/adl -nodebug ${REP_DOFUS}/share/META-INF/AIR/application.xml ${REP_DOFUS}/share" > $REP_DOFUS/bin/Dofus
sed -i '1i#!/bin/bash' $REP_DOFUS/bin/Dofus
chmod 755 $REP_DOFUS/bin/Dofus
echo "${REP_AIR}/bin/adl -nodebug ${REP_REG}/share/META-INF/AIR/application.xml ${REP_REG}/share" > $REP_REG/bin/Reg
sed -i '1i#!/bin/bash' $REP_REG/bin/Reg
chmod 755 $REP_REG/bin/Reg

#On créer le .desktop puis on le copie sur le Bureau
mkdir -p $HOME/.local/share/applications

echo "[Desktop Entry]
Encoding=UTF-8
Type=Application
Name="Dofus Updater"
Icon="$REP_DOFUS/share/icon/dofus-icon-48.png"
Exec="$REP_DOFUS/share/UpLauncher"
Path="$REP_DOFUS/share/"
Categories=Game" > $HOME/.local/share/applications/DofusUpdater.desktop

cp $HOME/.local/share/applications/DofusUpdater.desktop $HOME/Bureau/DofusUpdater.desktop
chmod 755 $HOME/Bureau/DofusUpdater.desktop

#Lancement de l'upLauncher pour les mises a jour puis pour jouer
chmod 755 $REP_DOFUS/share/UpLauncher
echo "Lancement de l'updater ..."
$REP_DOFUS/share/UpLauncher
