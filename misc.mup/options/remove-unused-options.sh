#!/bin/bash

cd /compile/source/linux-stable-mtup

for i in `cat /compile/doc/stable-mt/misc.mup/options/options-to-remove-generic.txt | grep -v ^#`; do
  echo $i
  ./scripts/config -d $i
done

for i in `cat /compile/doc/stable-mt/misc.mup/options/options-to-remove-special.txt | grep -v ^#`; do
  echo $i
  ./scripts/config -d $i
done
