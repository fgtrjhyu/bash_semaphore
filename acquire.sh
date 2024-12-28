#!/usr/bin/bash

BASEDIR=$(dirname $0)
LOCKDIR=${BASEDIR}/lock
LOCKQUEUED=${LOCKDIR}/queued
LOCKFILES=${LOCKDIR}/count/*

longsleep() {
  flock -s ${LOCKQUEUED} sleep 600
}

while true; do
  for LOCKFILE in ${LOCKFILES[@]}; do
    export LOCKFILE
    if flock -n -x -w 0 "${LOCKFILE}" ${BASEDIR}/command.sh; then
      printf "%s: %02d: unlocked.\n" "${LOCKFILE}" "${INDEX}"
      break 2
    fi
  done

  # Prevent the display of messages when processes receives SIGALRM
  (longsleep 2>/dev/null)
done
flock -x ${LOCKDIR} fuser -s -k -ALRM ${LOCKQUEUED}
