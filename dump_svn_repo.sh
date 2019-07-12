#!/bin/sh
#============================================================================
# Nombre: dump_svn_repo.sh
# Autor: jlira
# Fecha: 11/07/19
# Descripcion: Elimina un respaldo anterior de svn y crea uno nuevo
# Uso: ./dump_svn_repo.sh [repo_dir] [backup_dir]
#      ./dump_svn_repo.sh /var/opt/svn/repo_name /var/opt/svn/backup
#=============================================================================

if [ "$#" ! -eq 0 ]; then
   REPO_DIR="/var/opt/svn/repo_name"
   BACKUP_DIR="/var/opt/svn/backup"
elif [ "$#" -lt 2 -o "$#" -gt 2 ]; then
   echo "Use: $(basename "$0") [repo_dir] [backup_dir]"
   exit 1
else
   REPO_DIR=$1
   BACKUP_DIR=$2
fi

BACKUP_FILE=$BACKUP_DIR"/svn_dump-$(date +"%Y-%m-%d-%T").dmp.gz" 
if [ -e $BACKUP_DIR/repo/* ]; then
      rm -Rf $BACKUP_DIR/*  
fi
svnadmin dump $REPO_DIR | gzip -9  > $BACKUP_FILE  