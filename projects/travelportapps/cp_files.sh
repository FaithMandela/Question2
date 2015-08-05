#!/bin/bash

cd $(dirname $0)

TOMCAT_PATH=/Users/henriquedn/Lab/Apache/tomcat
WEBAPP_NAME=travelportapps


echo 'Copying Xml...'
cp ~/Lab/Repo/baraza_projects/baraza/projects/PROJECT/configs/ujenzi.xml ~/Lab/Apache/tomcat/webapps/travelportapps/WEB-INF/configs/
echo 'Copying Reports....'
cp ~/Lab/Android/baraza/projects/ujenzi/reports/*.* ~/Lab/Apache/tomcat.eclipse/webapps/nujenzi/reports/
echo 'Done...'
