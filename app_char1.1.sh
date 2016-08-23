#!/bin/bash
## 程序名称：           app_char2.sh
## 程序版本：           v1.1
## 程序作者：           Yang
## 程序用法：           app_char.sh { filename } { number }
## 程序历史：
## 程序功能：统计文档中英文字母的个数，区分大小写
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
        pat=$2
        pas=$3
        awk 'BEGIN{ FS="" } 
        NR>'$pat' && NR<='$pas'{for(i=1;i<=NF;i++)
        {
                if($i>="a" && $i<="z") {list[$i]++;continue}
                if($i>="A" && $i<="Z") list[$i]++
        }
        };END{for(j=97;j<=122;++j){a=sprintf("%c",j);printf("%s ",list[a])};
                for(j=65;j<=90;++j){a=sprintf("%c",j);printf("%s\t",list[a])}}' $1
}

## 参数判断·
[ -f "$1" ] && FILENAME=$1 || usage

[ $2 -gt 0 ] >/dev/null 2>&1 && NUM=$2 || usage

#文件的总行数
HS=$(cat $FILENAME|wc -l)

## Main 
for((h=0;h<$NUM;h++))
do
        MINHS=$[ $(($h*$HS))/$NUM ]
        MAXHS=$[ $((($h+1)*$HS))/$NUM ]
        tongji $FILENAME $MINHS $MAXHS >./tmpfile.$h &
        PID[$h]=$!
done
wait
for((j=0;j<$NUM;j++))
do
        read -a a$j <./tmpfile.$j
done

#bb=(a b c d e f g h i j k l m n o p q r s t u v w s y z A B C D E F G H I J K L M N O P Q R S T U V W S Y Z)
bb=abcdefghijklmnopqrstuvwsyzABCDEFGHIJKLMNOPQRSTUVWSYZ

for((z=0;z<52;z++))
do
        sum=0
        for((j=0;j<$NUM;j++))
        do
                aa=$(eval echo \${a$j[$z]})
                sum=$[$aa + $sum]
        done 
        if [ $z -eq 26 ];then
                printf "\n"
        fi
        printf "%s:%d\t" "${bb:$z:1}" "$sum"
done
find . -name "tmpfile.*" -a -type f -exec rm -f {} \;
