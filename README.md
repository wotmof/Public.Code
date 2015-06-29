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
<table width="65%" border="0">
<tr>
<th colspan=3><bold>[/etc/dbcmgt.conf]</bold></th>
</tr>
<tr>
<td>_container_name_</td>
<td>_ORACLE_SID_</td>
<td>_startup_option_</td>
</tr>
</table>
<i>(values are separated by tabs or spaces)</i>


<br>
pmdg.lsp
--------------
Poor Men Data Guard Log Shipping script.<br>
It syncs Oracle Database archived redo log from PRIMARY to STANDBY, for recovery.<.br>
Copy/install as oracle in your scripts dir.<br>
Set to run via crontab at <your_log_switching_rate>.<br>
<br>
pmdg.rcv
--------------
Poor Men Data Guard Recovery.<br>
It applies archived redo log shipped by PRIMARY, to the STANBY database (which is in MOUNT).<br>
Copy/install as oracle in your scripts dir.<br>
Set to run via crontab at <your_log_switching_rate>.<br>


