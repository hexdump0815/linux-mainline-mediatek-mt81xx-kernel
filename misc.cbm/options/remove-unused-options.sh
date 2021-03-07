#!/bin/bash

cd /compile/source/linux-stable-mt

for i in `cat /compile/doc/stable-mt/misc.cbm/options/options-to-remove-generic.txt | grep -v ^#`; do
  echo $i
  ./scripts/config -d $i
done

for i in `cat /compile/doc/stable-mt/misc.cbm/options/options-to-remove-special.txt | grep -v ^#`; do
  echo $i
  ./scripts/config -d $i
done
