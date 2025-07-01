#!/bin/sh

cd $( dirname $0 )
THIS_SCRIPT_DIR="$( pwd )"
SRCDIR="$THIS_SCRIPT_DIR/q4os-tools/"
BUILDDIR1="$THIS_SCRIPT_DIR/debian/q4os-i18n"
BUILDDIR2="/tmp/.wkgh18nbuild2"
rm -rf $BUILDDIR1/ $BUILDDIR2/
# echo $BUILDDIR1

cd $SRCDIR

#for CFDIR in *
for CFDIR in cs de fr he hu it ja pl pt pt_BR ru nl es es_AR ; do
  if [ -d "$CFDIR" ] ; then
    echo "Processing-1 $CFDIR"
    cd $CFDIR
    find . -name \*.po -execdir sh -c 'msgfmt "$0" -o `basename $0 .po`.mo' '{}' \; #--use-fuzzy
    cd ..
    mkdir -p $BUILDDIR1/$CFDIR/LC_MESSAGES
    mv $CFDIR/*.mo $BUILDDIR1/$CFDIR/LC_MESSAGES/
    # cp $CFDIR/*.po $BUILDDIR1/$CFDIR/LC_MESSAGES/
  fi
done

cd $BUILDDIR1/
#remove calamares files
find . -name calamares-debian.mo -execdir rm '{}' \;
#remove q4os-shortcuts files
find . -name q4os-shortcuts.mo -execdir rm '{}' \;

#remove untranslated files - 1
cd $BUILDDIR1/
for CFDIR in * ; do
  if [ -d "$CFDIR" ] ; then
    echo "Processing-2 $CFDIR"
    cd $CFDIR
    #find . -name update-manager.mo -execdir rm '{}' \;
    #find . -name appsetup2.mo -execdir rm '{}' \;
    cd ..
  fi
done

#remove untranslated files - 2, as not translated yet
echo "Processing-3"
rm he/LC_MESSAGES/desktop-profiler.mo
rm he/LC_MESSAGES/software-centre.mo
rm he/LC_MESSAGES/update-manager.mo
rm he/LC_MESSAGES/um_config.mo
rm he/LC_MESSAGES/appsetup2.mo
# rm ja/LC_MESSAGES/software-centre.mo
# rm ja/LC_MESSAGES/update-manager.mo
# rm ja/LC_MESSAGES/um_config.mo
# rm ja/LC_MESSAGES/appsetup2.mo

echo "Processing-4"
mkdir pt_PT/
rsync -a --ignore-existing pt/* pt_PT/
mkdir de_DE/
rsync -a --ignore-existing de/* de_DE/
mkdir de_AT/
rsync -a --ignore-existing de/* de_AT/
mkdir de_CH/
rsync -a --ignore-existing de/* de_CH/
# mkdir pt_BR/
# rsync -a --ignore-existing pt/* pt_BR/
# mkdir es_AR/
# rsync -a --ignore-existing es/* es_AR/

echo "Building filesystem"
cd $BUILDDIR1/
for CFDIR in * ; do
  if [ -d "$CFDIR" ] ; then
    echo "Copying > $CFDIR"
    mkdir -p $BUILDDIR2/usr/share/locale/$CFDIR/LC_MESSAGES/
    mkdir -p $BUILDDIR2/opt/trinity/share/locale/$CFDIR/LC_MESSAGES/
    mv $CFDIR/LC_MESSAGES/cpuqinfo.mo $BUILDDIR2/usr/share/locale/$CFDIR/LC_MESSAGES/
    mv $CFDIR/LC_MESSAGES/welcome-screen.mo $BUILDDIR2/usr/share/locale/$CFDIR/LC_MESSAGES/
    mv $CFDIR/LC_MESSAGES/q4os-base.mo $BUILDDIR2/usr/share/locale/$CFDIR/LC_MESSAGES/
    cp -r $CFDIR/LC_MESSAGES $BUILDDIR2/opt/trinity/share/locale/$CFDIR/
    rm -r $CFDIR
  fi
done
cd ../
rm -r $BUILDDIR1
mv $BUILDDIR2 $BUILDDIR1
