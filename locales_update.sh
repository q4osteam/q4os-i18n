#!/bin/sh

if [ -z "$1" ] ; then
  echo "need parameter, exiting .."
  exit 1
fi

if [ ! -f "src/.pot_empty/$1.pot" ] ; then
  echo "missing \"$1.pot\" file, exiting .."
  exit 2
fi

cd src
for CFDIR in *
do
  if [ -d "$CFDIR" ] ; then
    cd $CFDIR
    if [ -f "$1.po" ] ; then
      echo "Updating $1.po"
      msgmerge -U --no-fuzzy-matching --no-wrap $1.po ../.pot_empty/$1.pot
      rm -f "$1.po~"
    else
      echo "Creating $1.po"
      cp ../.pot_empty/$1.pot $1.po
    fi
    cd ..
  fi
done
