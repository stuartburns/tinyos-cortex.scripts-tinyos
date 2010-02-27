#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog -*-

. $(dirname $0)/main.subr

PATH=$prefix/bin:$PATH

modules="nesc tinyos-tools stow"

for module in $modules; do
    $scriptdir/$module.sh download build install
done

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4:
