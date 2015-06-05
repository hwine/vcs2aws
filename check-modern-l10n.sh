#!/usr/bin/env bash
# Script to quickly spot check Modern b/w AWS and production
# expects $SITE1_IP and $SITE2_IP to be exported, or set inside the script before use.
# TODO: Add usage()

#set -x

# OSX 10.10 still ships with bash v3
[[ $BASH_VERSINFO -ge 4 ]] || {
    echo "bash version 4 needed, you have $BASH_VERSINFO"
    exit 1
} 1>&2

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

var_check() {

    for v in SITE1_IP SITE2_IP SITE1 SITE2
    do
        if [[ ! -v "$v" ]]
        then
            warn "\$$v not set."
            # usage
            exit 1
        fi
    done
}


#SITE1_IP= # production
#SITE2_IP= # AWS

SITE1="/home/ec2-user/live/vcs_sync/build/target"
SITE2="/home/vcs2vcs/vcs_sync/build/target"

SITE1_USER="ec2-user"
SITE2_USER="vcs2vcs"

var_check

# stderr messes up output, close it, now that we're done with our own
# message
exec 2>&-

# Assumes l10n occurs in name
for dir in $(ssh -t ec2-user@$SITE1_IP "sudo ls $SITE1 | col | grep l10n")
do

    dir=$(echo $dir | tr -d [:space:])
    info "Checking $dir"
    site1_commit=$(ssh -t ec2-user@$SITE1_IP sudo -u $SITE1_USER git --no-pager -C $SITE1/$dir ls-remote -h ./ master | col | awk '{print $1}')
    site2_commit=$(ssh -t ec2-user@$SITE2_IP sudo -u $SITE2_USER git --no-pager -C $SITE2/$dir ls-remote -h ./ master | col | awk '{print $1}')

    echo "$site1_commit $site2_commit"
    if [[ "$site1_commit" == "$site2_commit" ]]
    then
        success "MATCH"
    else
        warn "NO MATCH"
    fi
    echo ""
done
