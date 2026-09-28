#!/bin/bash

ROOT_PART=/dev/sda2
OFFSET=$(losetup|awk '{print $3}'|tail -n1)
losetup --show -o ${OFFSET} -f -P ${ROOT_PART} 1> /tmp/loopdev
LOOPDEV=$(cat /tmp/loopdev)
mkfs.f2fs -f ${LOOPDEV}
