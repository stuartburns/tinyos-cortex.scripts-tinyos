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

function tinyos_msp430::version() {
    local relase=$tinyos_msp430_release
    if [[ $release == current ]]; then
        echo tinyos-msp430
    else
        echo $release
    fi
}

function tinyos_msp430::config() {
    tinyos_main::config
    tinyos_msp430=$(tinyos_msp430::version)
}

function download() {
    tinyos_msp430::config

    if [[ $tinyos_msp430_release == current ]]; then
        clone --sudo git $tinyos_msp430_repo $tinyos_src/$tinyos_msp430
    else
        fetch $tinyos_msp430_url/$tinyos_msp430.tar.gz
    fi
    return 0
}

function prepare() {
    return 0
}

function build() {
    return 0
}

function install() {
    tinyos_msp430::config

    if [[ $tinyos_msp430_release == current ]]; then
        :
    else
        [[ -d $tinyos_src ]] || do_cmd sudo mkdir -p $tinyos_src
        copy --sudo $tinyos_msp430.tar.gz $tinyos_src/$tinyos_msp430
    fi

    [[ -d $tinyos_root ]] \
        || do_cmd sudo mkdir -p $tinyos_root
    [[ -d $tinyos_stow ]] \
        || do_cmd sudo mkdir -p $tinyos_stow
    do_cd $tinyos_stow
    do_cmd "sudo rm -f tinyos-msp430*"
    do_cmd "sudo ln -s $tinyos_src/$tinyos_msp430 ."
    do_cmd "sudo stow -R -t $tinyos_root *"
}

function cleanup() {
    return 0
}

main "$@"

# Local Variables:
# indent-tabs-mode: nil
# End:
# vim: set et ts=4 sw=4:
