# Présentation

Ensemble de scripts trouvés sur le net afin d'installer Dofus sur GNU/Linux.

Ce dépôt est également en relation avec quelques infos sur un wiki : https://olivier.dossmann.net/wiki/astuces/jeux/dofus

# Dofus.sh

Dernier script en date pour installer Dofus sur GNU/Linux : 

  * testé sur : Sabayon Linux 14, Sabayon Linux 16
  * disponible sur : http://ferora.fr/Dofus.sh
  * auteur : Ferora Le Feu

## Problème rencontré

Après premier lancement, le script Dofus ne se lance plus et donne quelque chose comme 

```bash
./Dofus: line 16: /home/od/Ankama/DofusLinux/transition/ankama-transition-dofus: Permission denied
```

Il suffit d'ajouter le droit d'exécution sur le fichier :

```bash
chmod +x $HOME/Ankama/DofusLinux/transition/transition
```

Puis de relancer Dofus.

# Liens utiles

  * https://olivier.dossmann.net/wiki/astuces/jeux/dofus
  * http://forum.dofus.com/fr/1087-ergonomie-performances/1905980-tuto-installation-dofus-gnu-linux-transition-sdk-adobe-air
  * https://doc.ubuntu-fr.org/dofus
  * https://aur.archlinux.org/packages/dofus
