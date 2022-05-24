#!/usr/bin/env bash

set -x
set -euo pipefail

main() {
    mkdir /usr/arm-linux-gnueabihf
    cd /usr/arm-linux-gnueabihf

    local dependencies=(xz-utils)
    apt-get update
    local purge_list=()
    for dep in "${dependencies[@]}"; do
        if ! dpkg -L "${dep}"; then
            apt-get install --assume-yes --no-install-recommends "${dep}"
            purge_list+=( "${dep}" )
        fi
    done

    local toolchain_version=8.3-2019.03
    curl --retry 3 -sSfL https://developer.arm.com/-/media/Files/downloads/gnu-a/${toolchain_version}/binrel/gcc-arm-${toolchain_version}-x86_64-arm-linux-gnueabihf.tar.xz -O
    tar --strip-components 1 -xJf gcc-arm-${toolchain_version}-x86_64-arm-linux-gnueabihf.tar.xz
    rm gcc-arm-${toolchain_version}-x86_64-arm-linux-gnueabihf.tar.xz

    if (( ${#purge_list[@]} )); then
      apt-get purge --assume-yes --auto-remove "${purge_list[@]}"
    fi
}

main "${@}"
