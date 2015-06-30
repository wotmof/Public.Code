#!/bin/bash
#
#
#
# Name		pmdg.lsp
# Path		/usr/local/utils/bin
# Description	Poor Men Data Guard LOG SHIPPING Procedure
#
#
#
#--------------------------------------------------
#          i'm not responsible for this
#                      __                   ___
#     .--.--.--.-----.|  |_.--------.-----.'  _|
#     |  |  |  |  _  ||   _|        |  _  |   _|
#     |________|_____||____|__|__|__|_____|__|
#                 made me do it!
#-------------------------------------------------:)
#
#
#
#
# ver 0.0.1 - JUL 2013 [UK]
#
#
#
#
#===============================================================================================
trap 'cleanup; clear; echo "Poor Men DataGuard stopped by user. ByE ByE."; echo; exit 0' 2 3

#===============================================================================================
function cleanup()
{
	msg="<-----Ending $_exec"; log2
	[ -f $___pidfile ] && rm $___pidfile
	[ -f $_out ] && rm $_out
	[ -f $_tmp ] && rm $_tmp
}

function log2()
{
	printf "%10s %8s %8s %-80s\n" "$(date +%d/%m/%Y)" "$(date +%H:%M:%S)" "$ORACLE_SID" "$msg" >> $___logfile
}

################################################################################# VariAbleS
_exec="pmdg.lsp"
base_dir="/usr/local/utils"
___logfile="${base_dir}/log/${_exec}.log"
_out="${baser_dir}/tmp/${_exec}.out"
_tmp="${baser_dir}/tmp/${_exec}.tmp"
_diff="${base_dir}/tmp/${_exec}$$.diff"
_rsync=$(which rsync)
_forceswitch="${base_dir}/bin/force.switch"
wait=60
retry=10

################################################################################# Pre-FligHT ChecKS
if [ $# -lt 4 ];
then
	clear; echo
	echo "Usage: $0 <oracle_sid> <archive_directory> <standby_host> <remote_archive_directory>"
	echo
	echo "Options:"
	echo "	<oracle_sid>			(Local) Database SID (PRIMARY) used for shipping/apply"
	echo "	<archive_directory>		Directory on file system where archived redo logs are stored"
	echo "	<remote_archive_directory>	Remote archie destination on STANDBY"
	echo; exit 1
else
	ORACLE_SID=$1; export ORACLE_SID
	arc_dir=$2
	remote_host=$3
	remote_arc_dir=$4
	if [ ! -d $arc_dir ];
	then
		clear; echo
		echo "ERROR: Given archive log directory doesn't exist on $(hostname)"
		echo; exit 1
	fi 	
	ORACLE_HOME=/oracle/app/oracle/product/10gR2; export ORACLE_HOME
	___pidfile="${base_dir}/var/run/${_exec}_${ORACLE_SID}.pid"
	___current="${base_dir}/tmp/${_exec}_${ORACLE_SID}.tmp"
fi

if [ -f $___pidfile ];
then
	clear; echo "WARNING: An instance of $_exec is already running"
	echo; exit 1
else
	echo "$$ $ORACLE_SID $(date +%s)" > $___pidfile
	msg="----->Starting $_exec on $(hostname)"; log2
fi
count=0
#################################################################### You ShOuLd CaLl Me MaIn
clear
wait=10; retry=3
arp=$(ls ${base_dir}/var/run | grep pid | grep $_exec | wc -l | awk '{print $1}')
if [ $arp -ge 3 ];
then
	end=0; cc=0
	while [ $end -eq 0 ]
	do
		arp=$(ls ${base_dir}/var/run | grep pid | grep $_exec | wc -l | awk '{print $1}')
		if [ $arp -ge 2 ];
		then
			for ((i=1;i<=${wait};i++)); do printf "."; sleep 1; done
			echo
			let cc++
		else
			end=1
		fi
		if [ $cc -eq $retry ];
		then
			echo "procedure timeout!"
			cleanup; exit 0
		fi
	done
fi

printf "%45s: %-45s\n" "ORACLE_SID" "$ORACLE_SID"
printf "%45s: %-45s\n" "Local Archive Directory" "$arc_dir"
printf "%45s: %-45s\n" "Remote Host" "$remote_host"
printf "%45s: %-45s\n" "Remote Archive Directory" "$remote_arc_dir"

printf "%-65s" "-Force archivelog switch"
msg="Forcing archivelog switch"; log2
$_forceswitch $ORACLE_SID > /dev/null
sleep 3
echo "[ done ]"


printf "%-65s" "-Synching archivelogs"
_cmd="$_rsync -uva ${arc_dir}/* oracle@${remote_host}:${remote_arc_dir}/"
eval "$_cmd" > $_out
grep ^[0-9] $_out | grep -v ^sending | grep -v ^sent | grep -v ^total > $_tmp
if [ -s $_tmp ];
then
	while read line
	do
		msg="$line shipped to $remote_host"; log2
	done < $_tmp
else
	msg="No archive logs shipped to $remote_host"; log2
fi
echo "[ done ]"

printf "%-65s" "-archivelog cleaning"
old_files=$(find $arc_dir -type f -mtime +1 -print | wc -l | awk '{print $1}')
###################
old_files=0
###################
if [ $old_files -gt 0 ];
then
	find $arc_dir -type f -mtime +1 -exec rm {} \;
	msg="Removed $old_files 2 days old archivelogs"; log2
else
	msg="No old archivelog files to remove"; log2
fi
echo "[ done ]"
		
cleanup

exit 0
##################################################################### YoU SHoUldN't CalL me at ALL!
