#!/bin/bash

ROOT_PART=/dev/sda2
PART_NUM="$(echo "$ROOT_PART" | grep -o "[[:digit:]]*$")"
ROOT_DEV="/dev/$(lsblk -no pkname "$ROOT_PART")"
PART_START=$(parted "$ROOT_DEV" -ms unit s p 2>/dev/null| grep "^${PART_NUM}" | cut -f 2 -d: | sed 's/[^0-9]//g')
PART_END=$(blockdev --getsz $ROOT_DEV|awk '$1=NF?$NF-1:X')
fdisk "$ROOT_DEV" <<EOF
p
d
$PART_NUM
n
p
$PART_NUM
$PART_START
$PART_END
n
p
w

