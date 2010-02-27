#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog; -*-

. $(dirname $0 )/main.subr

function download() {
    cd $buildtop
    [[ -f $nesc.tar.gz ]] \
        || fetch $url_nesc/$nesc.tar.gz \
        || die "can not download $nesc.tar.gz from $url_nesc"
    return 0
}

function prepare() {
    cd $buildtop
    rm -rf $builddir
    tar xzf $nesc.tar.gz
    mv $nesc $builddir

    if [[ "$scriptdir/$nesc-fix_*.patch" ]]; then
        for p in $scriptdir/$nesc-fix_*.patch; do
            patch -d $builddir -p1 < $p \
                || die "patch $p failed"
        done
    fi

    if is_osx_snow_leopard; then
        if [[ "$scriptdir/$nesc-osx_*.patch" ]]; then
            for p in $scriptdir/$nesc-osx_*.patch; do
                patch -d $builddir -p1 < $p \
                    || die "patch $p failed"
            done
        fi
    fi
    return 0
}

function build() {
    cd $builddir
    ./configure --prefix=$prefix --disable-nls \
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
