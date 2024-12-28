#!/usr/bin/bash

SIZE=$(( ( ${RANDOM} % 3 )  * 1024 * 1024 * 1024 ))

printf "%s: %02d: locked: iosize=%d.\n" "${LOCKFILE:-none}" "${INDEX:-0}" "${SIZE}"
if [[ ${SIZE} -gt 0 ]]; then
  dd if=/dev/urandom of=/dev/null count=1 bs=${SIZE} >/dev/null 2>&1
  exit 0
else
  exit 32
fi
