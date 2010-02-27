#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog; -*-
#
#  Copyright (C) 2010 Tadashi G. Takaoka
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

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
