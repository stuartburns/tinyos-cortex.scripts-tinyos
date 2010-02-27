#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog -*-

. $(dirname $0 )/main.subr

function download() {
    cd $buildtop
    [[ -d stow ]] \
        || git clone $repo_stow \
        || die "can not clone $repo_stow"
    return 0
}

function prepare() {
    return 0
}

function build() {
    rm -rf $builddir
    mkdir $builddir
    cd $builddir
    ../stow/configure --prefix=$prefix \
        || die "configure failed"
    make -j$(num_cpus) \
        || die "make filed"
}

function install() {
    cd $builddir
    sudo make install
}

function cleanup() {
    cd $buildtop
    rm -rf $builddir
}

main "$@"

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4:
