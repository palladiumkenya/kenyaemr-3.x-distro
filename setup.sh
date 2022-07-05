#!/bin/bash

#######
# Copies artifacts to the specified directories.
######

MODULES_DIR=/var/lib/OpenMRS/modules
TOMCAT_DIR=/var/lib/tomcat9/webapps
FRONTEND_DIR=/var/lib/OpenMRS/frontend
CONFIGURATION_DIR=/var/lib/OpenMRS/configuration

#script directory
CURRENT_DIR=$(pwd)
SCRIPT_DIR=$(dirname "$0")

if [ "$SCRIPT_DIR" = '.' ]; then
  SCRIPT_DIR="$CURRENT_DIR"
fi
echo script directory: "${SCRIPT_DIR}"

# MySQL settings
mysql_user="test"
mysql_password="test"
mysql_base_database="openmrs"

# Read MySQL password from stdin if empty
if [ -z "${mysql_password}" ]; then
  echo -n "Enter MySQL ${mysql_user} password: "
  # shellcheck disable=SC2162
  read -s mysql_password
  echo
fi

# Check MySQL password
echo exit | mysql --user=${mysql_user} --password="${mysql_password}" -B 2>/dev/null
if [ "$?" -gt 0 ]; then
  echo "MySQL ${mysql_user} password incorrect"
  exit 1
else
  echo "MySQL ${mysql_user} password correct."
fi
echo
echo "Stopping tomcat..."
echo
sudo service tomcat9 stop

echo "upgrading Concept Dictionary to the latest"
mysql --user=${mysql_user} --password=${mysql_password} ${mysql_base_database} <"${SCRIPT_DIR}/dictionary/kenyaemr_2x_concepts_dump-2022-05-27.sql"
echo

if [ "$?" -gt 0 ]; then
  echo "MYSQL encountered a problem while processing KenyaEMR concepts."
  exit 1
else
  echo "Successfully updated concept dictionary .........................."
fi

echo "Deleting liquibase entries for ETL modules updates"
mysql --user=${mysql_user} --password=${mysql_password} ${mysql_base_database} -Bse "DELETE FROM liquibasechangelog where id like 'kenyaemrChart%';"
echo

#echo "Truncating old drugs order_set and order_set_members"
#mysql --user=${mysql_user} --password=${mysql_password} ${mysql_base_database} <"${SCRIPT_DIR}/scripts/update_drugs.sql"
#
#echo "upgrading drug table to the latest"
#mysql --user=${mysql_user} --password=${mysql_password} ${mysql_base_database} <"${SCRIPT_DIR}/drugs/drug_2x_27_05_2022.sql"
#echo
#
#if [ "$?" -gt 0 ]; then
#  echo "MYSQL encountered a problem while processing KenyaEMR drugs."
#  exit 1
#else
#  echo "Successfully updated drugs .........................."
#fi

echo "Deleting old artifacts files."
echo
sudo rm -R ${MODULES_DIR}/*.omod
sudo rm -R ${FRONTEND_DIR}/*
sudo rm -R ${TOMCAT_DIR}/openmrs*
echo "Finished deleting old artifacts."
echo

echo "Copying new war file."
echo
sudo cp "${CURRENT_DIR}"/webapps/*.war ${TOMCAT_DIR}/

echo "Copying new .omod files."
echo
sudo cp "${CURRENT_DIR}"/modules/*.omod ${MODULES_DIR}/
echo "Finished copying new .omod files."
echo

echo "Copying frontend assets."
echo
sudo cp "${CURRENT_DIR}"/frontend/* ${FRONTEND_DIR}/
echo "Finished copying frontend assets."
echo

echo "Granting read permission to the modules directory: ${MODULES_DIR}."
sudo chmod --recursive +r ${MODULES_DIR}/*.omod
sudo chown tomcat:tomcat --recursive ${MODULES_DIR}/*.omod

echo
echo "Starting tomcat..."
echo
sudo service tomcat9 start
