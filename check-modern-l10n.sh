#!/bin/bash
# Script to quickly spot check Modern b/w AWS and production
# expects $SRC_IP and $DST_IP to be exported, or set inside the script before use.
# TODO: Add usage()

#set -x

exec 2<&-

# Coloured logging
info() {
    echo "$(tput setaf 3)$*$(tput sgr0)";
}
success() {
    echo "$(tput setaf 2)$*$(tput sgr0)";
}
warn() {
    echo "$(tput setaf 1)$*$(tput sgr0)";
}


#SRC_IP= # production
#DST_IP= # AWS

SRC="/home/ec2-user/live/vcs_sync/build/target"
DST="/home/vcs2vcs/vcs_sync/build/target"

#for dir in $(ls $SRC | grep l10n) # Assumes l10n occurs in name
for dir in $(ssh -t ec2-user@$SRC_IP "sudo ls $SRC | grep l10n")
do

    dir=$(echo $dir | tr -d [:space:])
    info "Checking $dir"
    src_commit=$(ssh -t ec2-user@$SRC_IP sudo git -C $SRC/$dir show HEAD --stat --no-color | grep commit | tr '[:space:]' '\n' | grep -v commit | tr -d '[:space:]')
    dst_commit=$(ssh -t ec2-user@$DST_IP sudo git -C $DST/$dir show HEAD --stat --no-color | grep commit | tr '[:space:]' '\n' | grep -v commit | tr -d '[:space:]')

    echo "$src_commit $dst_commit"
    if [[ "$src_commit" == "$dst_commit" ]]
    then
        success "MATCH"
    else
        warn "NO MATCH"
    fi
    echo ""
done
