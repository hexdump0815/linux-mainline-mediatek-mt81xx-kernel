#!/bin/bash

cd /compile/source/linux-stable-mtup

for i in `cat /compile/doc/stable-mt/misc.mup/options/docker-options-mod.txt | grep -v ^#`; do
  echo $i
  ./scripts/config -m $i
done

for i in `cat /compile/doc/stable-mt/misc.mup/options/docker-options-yes.txt | grep -v ^#`; do
  echo $i
  ./scripts/config -e $i
done
