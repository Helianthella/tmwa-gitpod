#!/bin/bash

# script run every time the gitpod instance launches

set -e # do not recover from errors
echo -e '\033]2;PLEASE WAIT\007' # set the tab title
echo "⌛  running startup script..."

function dirty_exit() {
    ret=$?

    if [ $ret -gt 0 ]; then
        echo
        echo "❌  an error occured when running command:"
        echo "$ ${BASH_COMMAND}"
    else
        exit 0
    fi
}

trap dirty_exit EXIT

cd /workspace/tmwa-gitpod
chmod u+x ./**/*.sh

REPO_REMOTE=$(git config --get remote.origin.url)

if [ "${REPO_REMOTE:8:10}" = "gitlab.com" ]; then
    export GITLAB_NAME=$(git config --get remote.origin.url | sed -r "s#.+\.com[:/]{1,2}([^/]+)/.+#\1#")
elif [ "${REPO_REMOTE:8:10}" = "github.com" ]; then
    export GITHUB_NAME=$(git config --get remote.origin.url | sed -r "s#.+\.com[:/]{1,2}([^/]+)/.+#\1#")
fi

if [[ ! -z "$GIT_AUTHOR_NAME" ]]; then
    git config --global user.name $GIT_AUTHOR_NAME
fi

if [[ ! -z "$GIT_AUTHOR_EMAIL" ]]; then
    git config --global user.email $GIT_AUTHOR_EMAIL
fi

REPO_LIST=(
    tmwa-server-data
    tmwa-client-data
    tmw-tools
    tmwa
)

function git_pull() {
    local DIR="$1"
    local REMOTE="upstream"
    local BRANCH="master"
    local UPSTREAM="$REMOTE/$BRANCH"

    pushd /workspace/tmwa-gitpod/.legacy/$DIR 1>/dev/null

    local UPSTREAM_URL=$(git config --get remote.upstream.url 2>/dev/null || echo "")
    local FORK_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")

    if [ -z "$UPSTREAM_URL" ] && [[ ! -z "$FORK_URL" ]]; then
        # this is a submodule: reverse the remotes
        git remote rename origin upstream
        UPSTREAM_URL="$FORK_URL"
        FORK_URL=""
    elif [[ ! -z "$UPSTREAM_URL" ]] && [ "$UPSTREAM_URL" = "$FORK_URL" ]; then
        # origin and upstream are the same: remove origin
        git remote remove origin
        FORK_URL=""
    fi

    git fetch -q $REMOTE 1>/dev/null

    if [[ ! -z "$GITHUB_NAME" ]] && [ -z "$FORK_URL" ]; then
        FORK_URL=$(git config --get remote.upstream.url | sed -r "s%://github.com/([^/]+)/(.+(\.git)?)%://github.com/$GITHUB_NAME/\2%")
        local FORK_EXISTS=$(git ls-remote -hq "$FORK_URL" master &>/dev/null || echo $?)
        if [ -z "$FORK_EXISTS" ] && [ "$FORK_URL" != "$UPSTREAM_URL" ]; then
            git remote add --fetch origin "$FORK_URL" 1>/dev/null
        fi
    fi

    local CURRENT=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")

    if [ -z "$CURRENT" ]; then
        # HEAD is detached: do nothing
        return
    fi

    local CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

    if [ "$CURRENT" = "$UPSTREAM" ] && [ "$CURRENT_BRANCH" = "$BRANCH" ]; then
        local LOCAL=$(git rev-parse @)
        #local REMOTE=$(git rev-parse "$UPSTREAM")
        local BASE=$(git merge-base @ "$UPSTREAM")

        if [ $LOCAL = $BASE ]; then
            # we are on upstream/master and can fast-forward
            git pull -q
        fi
    fi
    popd 1>/dev/null
}

for i in "${REPO_LIST[@]}"; do
    git_pull "$i" &
done; wait


# set up the dotfiles and custom mods
. /workspace/tmwa-gitpod/scripts/dotfiles.sh

echo
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo
echo "✅  all done"

cd /workspace/tmwa-gitpod/.legacy
#clear
