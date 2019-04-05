FROM centos:centos7
RUN yum update -y &&  yum -y install wget && yum install unzip -y && yum install git-core -y
# Prepare environment
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat
ENV ANT_HOME /opt/ant
ENV IVY_HOME  /opt/ivy
ENV JENKINS_HOME /opt/jenkins
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$ANT_HOME/bin:$IVY_HOME/bin

# Install Oracle Java8
ENV JAVA_VERSION 8u202
ENV JAVA_BUILD 8u202-b08
ENV JAVA_DL_HASH 1961070e4c9b4e26a04e7f5a083f551e

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 http://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
 tar -xvf jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
 rm jdk*.tar.gz && \
 mv jdk* ${JAVA_HOME}

# Install Tomcat
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.5.39

RUN wget http://mirrors.estointernet.in/apache/tomcat/tomcat-8/v8.5.39/bin/apache-tomcat-8.5.39.tar.gz && \
 tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}


RUN chmod +x ${CATALINA_HOME}/bin/*sh
WORKDIR ${CATALINA_HOME}/webapps
RUN wget http://ftp-nyc.osuosl.org/pub/jenkins/war-stable/2.150.3/jenkins.war


#Ant Installation
ENV ANT_VERSION  1.10.5
RUN wget https://www-eu.apache.org/dist//ant/binaries/apache-ant-${ANT_VERSION}-bin.zip && \
 unzip apache-ant-${ANT_VERSION}-bin.zip && \
 rm apache-ant-${ANT_VERSION}-bin.zip && \
 mv apache-ant* ${ANT_HOME}


#Ivy Installation
ENV IVY_VERSION 2.4.0
RUN wget http://archive.apache.org/dist/ant/ivy/2.4.0-rc1/apache-ivy-2.4.0-rc1-bin-with-deps.tar.gz && \
 tar -xvf apache-ivy-${IVY_VERSION}-rc1-bin-with-deps.tar.gz && \
 rm apache-ivy-${IVY_VERSION}-rc1-bin-with-deps.tar.gz && \
 mv apache-ivy* ${IVY_HOME} && \
 cp ${IVY_HOME}/*.jar ${ANT_HOME}/lib && \
 cd ${IVY_HOME}/src/example/hello-ivy && \
 ant


#Mercurial Intallation
ENV MERCURIAL_VERSION 4.0-0.9
RUN wget https://www.mercurial-scm.org/release/centos7/RPMS/x86_64/mercurial-${MERCURIAL_VERSION}_rc.x86_64.rpm && \
 rpm -ivh mercurial-${MERCURIAL_VERSION}_rc.x86_64.rpm
WORKDIR /root

ENTRYPOINT /opt/tomcat/bin/startup.sh ; /bin/sh
EXPOSE 8080

