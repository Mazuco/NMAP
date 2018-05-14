#!/bin/bash
#nmap-mon.sh
#Uma Shell para enviar e-mail ao admin quando são detectadas mudanças em uma rede usando Nmap e Ndiff.
#Lembra-se de fazer os ajustes
#Criado por Paulino Calderon e Modificado por Vitor Mazuco

#
#Configuração
#
NETWORK="SEUDOMINIO.COM"
ADMIN=SEU@EMAIL.COM
NMAP_FLAGS="-sV -Pn -p- -T4"
BASE_PATH=/usr/local/share/nmap-mon/
BIN_PATH=/usr/local/bin/
BASE_FILE=base.xml
NDIFF_FILE=ndiff.log
NEW_RESULTS_FILE=resultados.xml
BASE_RESULTS="$BASE_PATH$BASE_FILE"
NEW_RESULTS="$BASE_PATH$NEW_RESULTS_FILE"
NDIFF_RESULTS="$BASE_PATH$NDIFF_FILE"

if [ -f $BASE_RESULTS ]
then
  echo "Verificando o Host $NETWORK"
  ${BIN_PATH}nmap -oX $NEW_RESULTS $NMAP_FLAGS $NETWORK
  ${BIN_PATH}ndiff $BASE_RESULTS $NEW_RESULTS > $NDIFF_RESULTS
  if [ $(cat $NDIFF_RESULTS | wc -l) -gt 0 ]
  then
    echo "Alterações de rede detectadas em $NETWORK"
    cat $NDIFF_RESULTS
    echo "Alertando o admin $ADMIN"
    mail -s "Alterações de rede detectadas em $NETWORK" $ADMIN < $NDIFF_RESULTS
  fi 
fi
