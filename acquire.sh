#!/usr/bin/bash

BASEDIR=$(dirname $0)
LOCKDIR=${BASEDIR}/lock
LOCKQUEUE=${LOCKDIR}/count
LOCKFILE=${LOCKQUEUE}/*
WAITSTAT=255

longsleep() {
  flock -s "${LOCKQUEUE}" sleep 600
}

RC=0
while true; do
  for LOCKFILE in ${LOCKFILE[@]}; do
    export LOCKFILE
    flock -E${WAITSTAT} -n -x "${LOCKFILE}" "${BASEDIR}/command.sh"
    RC=$?
    if [[ "${RC}" -ne "${WAITSTAT}" ]]; then
      break 2
    fi
  done
  # Prevent the display of messages when processes receives SIGALRM
  (longsleep 2>/dev/null)
done
printf "%s: %02d: end: exitcode=%03d.\n" "${LOCKFILE}" "${INDEX}" "${RC}"
flock -x ${LOCKDIR} fuser -s -k -ALRM ${LOCKQUEUE}
