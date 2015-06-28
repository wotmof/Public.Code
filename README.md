Public.Code
==============

oramgt
--------------
Script used from within a LXC (Linux Container) to manage Oracle databases.<br>
Copy/install the script (as oracle, set to be exec "chmod +x") in oracle home:<br>
/home/oracle/oramgt<br>
<br>
dbcmgt
--------------
The script that calls oramgt from the container's host, to manage databases.<br>
Copy/install (as root, set to be exec "chmod +x ") in bin's dir:<br>
/usr/bin/dbcmgt<br>
<br>
dbcmgt.conf
--------------
dbcmgt configuration file, basically filters containers to list.<br>
Create in /etc:<br>
/etc/dbcmgt.conf<br>

