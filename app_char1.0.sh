#!/bin/bash
## 程序名称：		app_char.sh
## 程序版本：		v1.0
## 程序作者：		Yang
## 程序用法：		app_char.sh { filename } { number }
## 程序历史：		
## 程序功能：统计文档中英文字母的个数，不区分大小写
##
##

## Set 设置
#set -o nounset #set -u
#set -o errexit #set -e
#set -o xtrace  #set -x

## Program information
PP=$(cd $(dirname $0) && pwd)
PN=$(basename $0 ".sh")
VER=1.0
#TMPFILE=$PP/$PN.log

## Function list
usage(){ echo "$PN.sh  { filename } { number } " && exit;}

## 主功能函数
tongji(){
	MIN=$2
	MAX=$3
	awk 'BEGIN{ FS="" } 
	NR>'$MIN' && NR<='$MAX'{for(i=1;i<=NF;i++)
	{
		if($i=="a" || $i=="A") {list[0]++;continue}
		if($i=="b" || $i=="B") {list[1]++;continue}
		if($i=="c" || $i=="C") {list[2]++;continue}
		if($i=="d" || $i=="D") {list[3]++;continue}
		if($i=="e" || $i=="E") {list[4]++;continue}
		if($i=="f" || $i=="F") {list[5]++;continue}
		if($i=="g" || $i=="G") {list[6]++;continue}
		if($i=="h" || $i=="H") {list[7]++;continue}
		if($i=="i" || $i=="I") {list[8]++;continue}
		if($i=="j" || $i=="J") {list[9]++;continue}
		if($i=="k" || $i=="K") {list[10]++;continue}
		if($i=="l" || $i=="L") {list[11]++;continue}
		if($i=="m" || $i=="M") {list[12]++;continue}
		if($i=="n" || $i=="N") {list[13]++;continue}
		if($i=="o" || $i=="O") {list[14]++;continue}
		if($i=="p" || $i=="P") {list[15]++;continue}
		if($i=="q" || $i=="Q") {list[16]++;continue}
		if($i=="r" || $i=="R") {list[17]++;continue}
		if($i=="s" || $i=="S") {list[18]++;continue}
		if($i=="t" || $i=="T") {list[19]++;continue}
		if($i=="u" || $i=="U") {list[20]++;continue}
		if($i=="v" || $i=="V") {list[21]++;continue}
		if($i=="w" || $i=="W") {list[22]++;continue}
		if($i=="x" || $i=="X") {list[23]++;continue}
		if($i=="y" || $i=="Y") {list[24]++;continue}
		if($i=="z" || $i=="Z") {list[25]++;continue}
	}
	};END{for(j=0;j<26;j++) printf ("%s ",list[j])}
	' $1
}

## 参数判断· filename 为要统计的文件名，num为线程数
[ -f "$1" ] && FILENAME=$1 || usage

[ $2 -gt 0 ] && NUM=$2 || usage

#文件的总行数
HS=$(cat $FILENAME|wc -l)

## Main 
# 
for((h=0;h<$NUM;h++))
do
	MINHS=$[ $(($h*$HS))/$NUM ]
	MAXHS=$[ $((($h+1)*$HS))/$NUM ]
	tongji $FILENAME $MINHS $MAXHS >./tmpfile.$h &
	PID[$h]=$!
done
wait ${PID[@]}
for((j=0;j<$2;j++))
do
	read -a a$j <./tmpfile.$j
done
bb=(A B C D E F G H I J K L M N O P Q R S T U V W S Y Z)
for((z=0;z<26;z++))
do
	sum=0
	for((j=0;j<$2;j++))
	do
	aa=$(eval echo \${a$j[$z]})
	sum=$[$aa + $sum]
	done 
printf "%s:%d\n" "${bb[$z]}" "$sum"
done
#删除临时文件
find . -name "tmpfile.*" -a -type f -exec rm -f {} \;
