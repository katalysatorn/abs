#!/bin/bash

source ./config/abs.conf

ROOTDIR=$(pwd)
echo $ROOTDIR

# Setup TMPDIR
if ! [[ -v "$TMPDIR" ]]; then
	TMPDIR=/tmp/abs
fi
echo "" > $TMPDIR/built

# Rsync
cd $PUBDIR

# for mirror in "${RSYNCMIRRORS[@]}"
# do
# 	rsync -rlptHvh --progress --safe-links --delete-delay --delay-updates $mirror $(basename $mirror)
# done

# Build custom-packages
for pkg in $SRCDIR/custom/*; do
	echo "$pkg" >> $TMPDIR/built
done
