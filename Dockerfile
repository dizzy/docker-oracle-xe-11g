FROM oraclelinux:7

MAINTAINER George Niculae <george.niculae79@gmail.com>

# copy Oracle RPM installer and config files
ADD oracle-xe-11.2.0-1.0.x86_64.rpma* /tmp/
ADD init.ora /tmp/init.ora
ADD initXETemp.ora /tmp/initXETemp.ora

# install dependencies
RUN yum install -y bc \
    libaio \
    net-tools \
    openssh-server

# reassemble RPM, install and configure Oracle XE and do the cleanup
RUN cat /tmp/oracle-xe-11.2.0-1.0.x86_64.rpma* > /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm && \
    rpm -ivh /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm && \
    mv /tmp/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts && \
    mv /tmp/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts && \
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure && \
    echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc && \
    chkconfig oracle-xe on && \
    rm /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm*

# configure ssh
RUN mkdir /var/run/sshd && \
    echo 'root:admin' | chpasswd && \
    sed -i 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    ssh-keygen -A

# Expose ports 22, 1521 and 8080
EXPOSE 22
EXPOSE 1521
EXPOSE 8080

# Change the hostname in the listener.ora file, start Oracle XE and the ssh daemon
CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora; \
	service oracle-xe start; \
	/usr/sbin/sshd -D
