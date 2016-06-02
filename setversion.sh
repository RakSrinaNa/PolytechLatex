#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage $0 version"
    exit 1
fi

VERSION="$1"
DATE="$(date +%y/%m/%d)"
echo "Setting version to $VERSION - $DATE"

sed -i "s~\(\\def\\polytechfileversion{\).*\(}\)~\1$VERSION\2~" polytech/polytech.cls
sed -i "s~\(\\def\\polytechfiledate{\).*\(}\)~\1$DATE\2~" polytech/polytech.cls

git add -u 
git commit -m "Bump version before tagging"
git tag -a "$VERSION" -m "Tag $VERSION"
git push
git push origin "$VERSION"

