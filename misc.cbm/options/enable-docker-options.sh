#!/bin/bash

cd /compile/source/linux-stable-mt

for i in `cat /compile/doc/stable-mt/misc.cbm/options/docker-options-mod.txt`; do
  echo $i
  ./scripts/config -m $i
done

for i in `cat /compile/doc/stable-mt/misc.cbm/options/docker-options-yes.txt`; do
  echo $i
  ./scripts/config -e $i
done
