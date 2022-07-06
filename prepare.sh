#!/bin/bash
############
# This script prepares the kenyaemr package zip file
# |-kenyaemr-package
# |--frontend
# |--modules
# |--webapp
# |--configurations
######

PACKAGE_DIR=kenyaemr-package

mkdir -p $PACKAGE_DIR

#clean modules directory
if [ -d "$PACKAGE_DIR/modules/" ]; then
  echo "Removing all files from $PACKAGE_DIR/modules ."
  rm -R $PACKAGE_DIR/modules/*
else
  echo "creating $PACKAGE_DIR/modules.."
  mkdir -p $PACKAGE_DIR/modules
fi

#copy kenyaemr custom war file.
mkdir -p $PACKAGE_DIR/webapps
cp -R webapps/*.war $PACKAGE_DIR/webapps

echo "Copying openmrs modules..."
cp -R pre-build-modules/* $PACKAGE_DIR/modules
cp -R package/target/sdk-distro/web/modules/* $PACKAGE_DIR/modules
echo "Done copying openmrs modules."

#prepare frontend directory
if [ -d "$PACKAGE_DIR/frontend/" ]; then
  echo "Removing all files from $PACKAGE_DIR/frontend ."
  rm -R $PACKAGE_DIR/frontend/*
else
  echo "creating $PACKAGE_DIR/frontend."
  mkdir -p $PACKAGE_DIR/frontend
fi

echo "Copying openmrs frontend modules..."
cp -R package/target/sdk-distro/web/frontend/* $PACKAGE_DIR/frontend


#prepare configuration directory
if [ -d "$PACKAGE_DIR/configuration/ampathforms" ]; then
  echo "Removing all files from $PACKAGE_DIR/configuration/ampathforms ."
 # rm -R $PACKAGE_DIR/configuration/ampathforms/*
else
  echo "creating $PACKAGE_DIR/configuration/ampathforms."
  mkdir -p $PACKAGE_DIR/configuration/ampathforms
fi

echo "Copying configuration..."
cp -R configuration/* $PACKAGE_DIR/configuration


#copy setup script
cp setup.sh $PACKAGE_DIR

#zip the output package directory

