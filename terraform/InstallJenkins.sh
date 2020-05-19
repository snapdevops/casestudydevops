#!/bin/bash
yum -y update
yum remove -y java
yum install -y java-1.8.0-openjdk
wget https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
yum install -y apache-maven
yum install -y git
yum update -y
yum install docker -y
chkconfig docker on
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import "https://jenkins-ci.org/redhat/jenkins-ci.org.key"
yum install -y jenkins
usermod -a -G docker jenkins
chkconfig jenkins on
service jenkins start
service docker start
