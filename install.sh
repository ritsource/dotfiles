#!/bin/bash

BIN_DIR="$HOME/.custom/scripts/bin"

mkdir -p $BIN_DIR

for srcfp in ./scripts/src/*.sh; do
    # only the filename, not path
    fn="$(basename $srcfp)"
    binfn="${fn%.*}"

    distfp="$BIN_DIR/$fn"
    distbinfp="$BIN_DIR/$binfn"

    cp $srcfp $distfp
    mv $distfp $distbinfp

    chmod +x $distbinfp
done

