#!/bin/bash
yum update -y
yum install java
cd /var/lib
wget "https://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz"
tar -xvf apache-tomcat-8.5.50.tar.gz
cd /var/lib/apache-tomcat-8.5.50
/var/lib/apache-tomcat-8.5.50/bin/startup.sh

