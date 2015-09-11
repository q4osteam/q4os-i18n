#!/bin/sh

cd src
#for CFDIR in *
for CFDIR in cs fr he pl pt pt_pt ru ; do
  if [ -d "$CFDIR" ] ; then
    echo "Processing-1 $CFDIR"
    cd $CFDIR
    find . -name \*.po -execdir sh -c 'msgfmt "$0" -o `basename $0 .po`.mo' '{}' \;
    cd ..
    mkdir -p ../../build/$CFDIR/LC_MESSAGES
    mv $CFDIR/*.mo ../../build/$CFDIR/LC_MESSAGES/
  fi
done

#remove untranslated files - 1
cd ../../build
for CFDIR in * ; do
  if [ -d "$CFDIR" ] ; then
    echo "Processing-2 $CFDIR"
    cd $CFDIR
    find . -name appsetup2.mo -execdir rm '{}' \;
    cd ..
  fi
done

#remove untranslated files - 2
echo "Processing-3"
rm cs/LC_MESSAGES/desktop-profiler.mo #not translated yet
rm he/LC_MESSAGES/desktop-profiler.mo #not translated yet
rm cs/LC_MESSAGES/software-centre.mo #not translated yet
rm he/LC_MESSAGES/software-centre.mo #not translated yet
rm fr/LC_MESSAGES/software-centre.mo #text over buttons
rm ru/LC_MESSAGES/software-centre.mo #text over buttons
