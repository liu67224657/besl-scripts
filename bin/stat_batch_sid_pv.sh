#!/bin/bash

str="hello,world,i,like,you,babalala"
arr=(${str//,/ })

for i in ${arr[@]}
do
    echo "===================SID:"$i" stat begin==================="
    ./stat_sid_pv.sh $1 $i $2 $3
    echo "===================SID:"$i" stat end==================="
done