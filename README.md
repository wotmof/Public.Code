Public.Code
==============

oramgt
--------------
Script used from within a LXC (Linux Container) to manage Oracle databases.
Copy/install the script (as oracle, set to be exec "chmod +x") in oracle home:
/home/oracle/oramgt

dbcmgt
--------------
The script that calls oramgt from the container's host, to manage databases.
Copy/install (as root, set to be exec "chmod +x ") in bin's dir:
/usr/bin/dbcmgt

dbcmgt.conf
--------------
dbcmgt configuration file, basically filters containers to list.
Create in /etc:
/etc/dbcmgt.conf

