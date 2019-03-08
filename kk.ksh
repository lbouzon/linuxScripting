#!/bin/ksh



waiTime=0

elapsed=50

running=0.005

let waitTime=$(($elapsed/$running))

echo $waitTime
