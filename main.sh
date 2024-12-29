#!/usr/bin/bash

BASEDIR=$(dirname $0)

APPS=(foo bar baz qux)

for INDEX in $(seq 1 100); do
  export INDEX
  export APP=${APPS[$(( ( ${RANDOM} + ${INDEX} ) % ${#APPS[@]} ))]}

  ${BASEDIR}/acquire.sh &
done

wait
echo "done"
