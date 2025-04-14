#!/bin/bash
#
#
set -e

TMPDIR=$(mktemp -d)
VERSION=$(date -u +%Y%m%d%H%M%S)

pushd $TMPDIR
git clone https://github.com/roscopeco/anos-toolchain.git
cd anos-toolchain
git submodule update --init --recursive
find . -name '.git*' -print0 | xargs -0 rm -rf
cd ..
mv anos-toolchain anos-toolchain-$VERSION
tar czf anos-toolchain-$VERSION.tar.gz anos-toolchain-$VERSION
zip -r anos-toolchain-$VERSION.zip anos-toolchain-$VERSION
popd
mv $TMPDIR/anos-toolchain-$VERSION.tar.gz $TMPDIR/anos-toolchain-$VERSION.zip .
rm -rf $TMPDIR

