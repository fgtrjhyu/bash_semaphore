#!/usr/bin/bash

BASEDIR=$(dirname $0)

for INDEX in $(seq 1 30); do
  export INDEX
  ${BASEDIR}/acquire.sh &
done

wait
echo "done"
