#!/bin/sh -e

version=$(grep '"version"' info.json | sed 's/.*: "//; s/",//')

dir=$(realpath $(dirname ${0}))
dirname=$(basename ${dir})

cd ${dir}/..
rm -f ~/.factorio/mods/magic_stone*
zip -r ~/.factorio/mods/magic_stone_${version}.zip ${dirname} -x \*/.??\* \*/\*.iml \*/$(basename $0)
