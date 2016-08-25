#!/bin/bash
## 程序名称：           app_char.sh
## 程序版本：           v2.1
## 程序作者：           Yang
## 程序用法：           app_char.sh { filename } { number } number不要超过cpu核心数
## 程序历史：
## 程序功能：多线程统计文档中英文字母的个数，不区分大小写
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
        NR>'$MIN' && NR<='$MAX'{
                for(i=1;i<=NF;i++)
                {
                        if($i ~ /[A-Za-z]/)list[toupper($i)]++
                }
        }END{
                for(j in list ){
                        printf("%c=%d\n",j,list[j])
                }
        }' $1
}

## 参数判断·
[ -f "$1" ] && FILENAME=$1 || usage

[ $2 -gt 0 ] >/dev/null 2>&1 && NUM=$2 || usage

#文件的总行数
HS=$(cat $FILENAME|wc -l)

## Main 

for((i=0;i<$NUM;i++))
do
        MINHS=$[ $(($i*$HS))/$NUM ]
        MAXHS=$[ $((($i+1)*$HS))/$NUM ]
        tongji $FILENAME $MINHS $MAXHS >./tmpfile.$i &
done
wait
cat tmpfile.*|awk -F"=" '{
                                sum[$1]=sum[$1]+$2
                        }
                END{
                        for(j in sum){
                                printf("%c:%d\n",j,sum[j])
                        }
                }'|sort 

find . -name "tmpfile.*" -a -type f -exec rm -f {} \;
