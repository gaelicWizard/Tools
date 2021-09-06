#!/bin/bash

str="/aaa/bbb/ccc.txt"
count=10000

s_cmdbase() {
let i=0
while(( i++ < $count ))
do
    a=$(basename $str)
done
}

s_varbase() {
let i=0
while(( i++ < $count ))
do
    a=${str##*/}
done
}

s_cmddir() {
let i=0
while(( i++ < $count ))
do
    a=$(dirname $str)
done
}

s_vardir() {
let i=0
while(( i++ < $count ))
do
    a=${str%/*}
done
}

time s_cmdbase
echo command basename
echo ===================================
time s_varbase
echo varsub basename
echo ===================================
time s_cmddir
echo command dirname
echo ===================================
time s_vardir
echo varsub dirname
