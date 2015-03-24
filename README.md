# docker-oracle-xe-11g
Oracle Express Edition 11g Release 2 on Oracle Linux 7

Inspired from wnamless/docker-oracle-xe-11g

<h2>Install as</h2>
docker pull dizzy/oracle-xe-11g

<h2>Run it as</h2>
docker run -d -p 49160:22 -p 49161:1521 dizzy/oracle-xe-11g

<h4>Connect to database</h4>
- hostname: localhost
- port: 49161
- sid: xe
- username: system
- password: oracle

<h4>Password for SYS & SYSTEM</h4>
- oracle

<h4>Login by SSH</h4>
- ssh root@localhost -p 49160
- password: admin





