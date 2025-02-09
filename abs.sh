#!/bin/bash

source ./config/abs.conf

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

buildpkg() {
	local repo=$1
	makepkg $MAKEPKGFLAGS
	mv *.pkg.tar.zst $REPODIR/$repo
	mv *.pkg.tar.zst.sig $REPODIR/$repo

	# Add built packages to repo
	cd $REPODIR/$repo
	repo-add --sign --include-sigs -nR $repo.db.tar.xz *.pkg.tar.zst
}

for repo in "${REPO_NAMES[@]}"; do
	MAKEPKGFILE=/etc/makepkg.conf
	if [[ -f $CONFIGDIR/$repo-makepkg.conf ]]; then
		MAKEPKGFILE="$CONFIGDIR/$repo-makepkg.conf"
	fi
	
	# Build custom-packages
	for pkg in $SRCDIR/custom/*; do
		cd $pkg
		buildpkg $repo
	done

	cd $TMPDIR
	# Build AUR packages
	for pkg in "${PACKAGELIST}"; do
		repoctl down -d $SRCDIR/aur -o build-order $pkg
		for build in $(cat $TMPDIR/build-order); do
			cd $SRCDIR/aur/$build
			buildpkg $repo
		done
	done
done
