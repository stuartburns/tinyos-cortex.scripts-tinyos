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

. $(dirname $0)/main.subr

function download() {
    cd $buildtop
    rm -rf $builddir
    if [[ -d $tinyos ]]; then
        cd $tinyos; cvs -q up; cd ..;
    else
        cvs -q -d $repo_tinyos co -P $tinyos \
            || die "can not fetch from cvs repository";
    fi
    return 0
}

function prepare() {
    cd $buildtop
    rm -rf $builddir
    cp -R $tinyos $builddir \
        || die "can not copy $tinyos"
    for p in $scriptdir/tinyos-tools-*.patch; do
        [[ -f $p ]] && patch -d $builddir -p1 < $p \
            || die "patch $p failed"
    done
    return 0
}

function build() { 
    cd $builddir/tools
    ./Bootstrap \
        || die "bootstrap failed"
    ./configure --prefix=$prefix --disable-nls \
        || die "configure failed"
    make -j$(num_cpus) \
        || die "make failed"
}

function install() {
    cd $builddir/tools
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
