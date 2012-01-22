#!/bin/bash -u
# -*- mode: shell-script; mode: flyspell-prog; -*-
#
# Copyright (c) 2012, Tadashi G Takaoka
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in
#   the documentation and/or other materials provided with the
#   distribution.
# - Neither the name of Tadashi G. Takaoka nor the names of its
#   contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.
#

source $(dirname $0)/main.subr
source $(dirname $0)/tinyos-main.subr

function tinyos_main::repo() {
    local release=$tinyos_main_release
    if [[ $release == current ]]; then
        echo $tinyos_main_repo/trunk
    else
        local version=$(tinyos_main::version)
        echo $tinyos_main_repo/tags/release_${version//[-.]/_}
    fi
}

function download() {
    tinyos_main::config
    [[ -d $tinyos_src ]] || do_cmd sudo mkdir -p $tinyos_src
    local dir=$tinyos_src/$tinyos_main
    clone --sudo svn $(tinyos_main::repo) $dir
    return 0
}

function prepare() {
    tinyos_main::config
    copy $tinyos_src/$tinyos_main $builddir
    for p in $scriptsdir/${tinyos_main}_*.patch; do
        do_patch $builddir $p -p1
    done
    return 0
}

function build() {
    tinyos_main::config
    do_cd $builddir/tools
    do_cmd ./Bootstrap \
        || die "bootstrap failed"
    do_cmd ./configure --prefix=$prefix --disable-nls \
        || die "configure failed"
    do_cmd make -j$(num_cpus) \
        || die "make failed"
}

function install() { 
    tinyos_main::config
    do_cd $builddir/tools
    do_cmd sudo make -j$(num_cpus) install

    [[ -d $tinyos_root ]] \
        || do_cmd sudo mkdir -p $tinyos_root
    [[ -d $tinyos_stow ]] \
        || do_cmd sudo mkdir -p $tinyos_stow
    do_cd $tinyos_stow
    do_cmd "sudo rm -f tinyos-2.*"
    do_cmd "sudo ln -s $tinyos_src/$tinyos_main ."
    do_cmd "sudo stow -R -t $tinyos_root *"
}

function cleanup() {
    tinyos_main::config
    do_cmd rm -rf $builddir
}

main "$@"

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4:
