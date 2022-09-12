#!/bin/bash
clear
echo  "############################"
echo  "##created.by mehran.safari##"
echo  "##        2022            ##"
echo  "############################"
##############
echo -n " Enter index name to lookup:"
read INAME
####
FROZENPATH="/frozendata"
echo " Default Splunk Frozen Indexes Path is "$FROZENPATH". is it ok? (y to continue or n to give new path):"
read  ANSWER1;
case "$ANSWER1" in
"y")
echo -e "OK Deafult Frozen Index Path Selected.";;
"n")
echo -e "Enter NEW Frozen Index Path:";
read FROZENPATH;;
esac
####
find "$FROZENPATH/$INAME" -type d -iname "db_*" -print > "./frozendb.txt"
ODATE=30
echo " oldest Frozen Bucket Should be "$ODATE" days old. is it ok?(press "y" to continue & "n" to change it):"
read ANSWER3
case $ANSWER3 in
y )
echo -e "OK Default Frozen Age Kept.";
break;;
n )
echo -e "Enter NEW Frozen AGE You Want:";
read ODATE; 
break;;
esac
BODATE=$(date --date="`date`-"$ODATE"days" +%s)
BCDATE=`date +%s`
#############
FILE1='./frozendb.txt'
 while read line; do
          LOGSTART=`echo $line | cut -d "_" -f3`;
          LOGEND=`echo $line | cut -d "_" -f2`;
if [[ $LOGEND -gt $BCDATE || $LOGSTART -lt $BODATE ]]; then
echo -e "******************************"
echo -e "Frozen Log Path You want: $line"
HLOGSTART=`date -d @"$LOGSTART"`
HLOGEND=`date -d @"$LOGEND"`
LOGSIZE=`du -hs "$line" | cut -d "/" -f1`
echo -e "*** this Bucket contains logs from: $HLOGSTART"
echo -e "*** this Bucket contains logs to: $HLOGEND "
echo -e "**** The Size Of This Log Is: $LOGSIZE"
echo -e "$line" >> "./frozenmatched.txt"
echo -e "******************************"
fi
done<$FILE1
############
sudo rm -rf "./frozendb.txt"
echo "Do you Want to DELETE this Logs?(y to DELETE): "
read  ANSWER3
FILE2='./frozenmatched.txt'
if [[ "$ANSWER3" == "y" ]]; then
while read line2; do
        sudo rm -rf "$line2"
        echo -e "DELETING of $line2 DONE."
done<$FILE2
fi
sudo rm -rf "./frozenmatched.txt"
##########
echo     "################################"
echo  -e "## GOOD LUCk WITH BEST REGARDS##"
echo     "################################"
#########

