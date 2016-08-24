#!/bin/bash
## 程序名称：           app_char2.sh
## 程序版本：           v1.4
## 程序作者：           Yang
## 程序用法：           app_char.sh { filename } { number }
## 程序历史：           v1.0 修改了awk的模块
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
        MIN=$2
        MAX=$3
        awk 'BEGIN{
                        FS=""
                }
                NR>'$MIN' && NR<='$MAX'{
                        for(i=1;i<=NF;i++)
                        {
                                if($i>="A" && $i<="z")list[$i]++
                        }
                }
                END{
                        for(j=97;j<=122;++j){
                                a=sprintf("%c",j);
                                b=sprintf("%c",j-32);
                                printf("%s ",list[a]+list[b])
                        }
                        printf"\n"
                }' $1 
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
        #mknod ./tmpfile$h p
        tongji $FILENAME $MINHS $MAXHS >>./tmpfile$h &
done
wait
cat tmpfile*|awk '{
                        for(i=1;i<=NF;i++){
                                a[i]=$i+a[i]
                        }
                }
                END{
                        for(i=1;i<=26;i++){
                                printf("%c:%d ",i+64,a[i])
                        }
                }'

find . -name "tmpfile*" -exec rm -f {} \;
