#!/bin/sh

cd src
#for CFDIR in *
for CFDIR in cs fr he ru pl ; do
  if [ -d "$CFDIR" ] ; then
    echo "Processing-1 $CFDIR"
    cd $CFDIR
    find . -name \*.po -execdir sh -c 'msgfmt "$0" -o `basename $0 .po`.mo' '{}' \;
    cd ..
    mkdir -p ../../build/$CFDIR/LC_MESSAGES
    mv $CFDIR/*.mo ../../build/$CFDIR/LC_MESSAGES/
  fi
done

#remove untranslated files
cd ../../build
for CFDIR in * ; do
  if [ -d "$CFDIR" ] ; then
    echo "Processing-2 $CFDIR"
    cd $CFDIR
    find . -name appsetup2.mo -execdir rm '{}' \;
    find . -name desktop-profiler.mo -execdir rm '{}' \;
    find . -name software-centre.mo -execdir rm '{}' \;
    cd ..
  fi
done
