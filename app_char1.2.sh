#!/bin/bash
## 程序名称：		app_char.sh
## 程序版本：		v1.2
## 程序作者：		Yang
## 程序用法：		app_cat.sh { filename } { number }
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
	min=$2
	max=$3
	awk 'BEGIN{ FS="" } 
	NR>'$min' && NR<='$max'{for(i=1;i<=NF;i++)
	{
                if($i>="a" && $i<="z") {list[$i]++;continue}
                if($i>="A" && $i<="Z") list[$i]++
        }
        };END{for(j=97;j<=122;j++){a=sprintf("%c",j);b=sprintf("%c",j-32);printf("%d\t",list[a]+list[b])}}' $1
}

## 参数判断·
[ -f "$1" ] && FILENAME=$1 || usage

[ $2 -gt 0 ] && NUM=$2 || usage

HS=$(cat $FILENAME|wc -l)
if [ $HS -lt 20000 ];then
	NUM=1
fi

## Main 
for((h=0;h<$NUM;h++))
do
	MINHS=$[ $(($h*$HS))/$NUM ]
	MAXHS=$[ $((($h+1)*$HS))/$NUM ]
	tongji $FILENAME $MINHS $MAXHS >./tmpfile.$h &
done
wait
for((j=0;j<$NUM;j++))
do
	read -a a$j <./tmpfile.$j
done
bb=ABCDEFGHIJKLMNOPQRSTUVWSYZ
for((z=0;z<26;z++))
do
	sum=0
	for((j=0;j<$NUM;j++))
	do
		aa=$(eval echo \${a$j[$z]})
		sum=$[$aa+$sum]
	done 
	printf "%s:%d\n" "${bb:$z:1}" "$sum"
done
find . -name "tmpfile.*" -a -type f -exec rm {} \;
