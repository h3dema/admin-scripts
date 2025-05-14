#!/bin/bash
#
#
# Examples:
#
# ./git_manager.sh create my-feature
#
# ./git_manager.sh delete my-feature -r
#
# ./git_manager.sh merge my-feature -r
#
# -r (optional): all affects the remote repository
#

# Detect default branch (main or master)
remote_master=$(git ls-remote --symref origin HEAD | awk '/^ref:/ {print $2}' | sed 's|refs/heads/||')
echo "Default branch is: $remote_master"


# print help and exit
usage() {
    echo "Usage: $0 <action> <branch_name> [-r]"
    exit 1
}

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
    usage
fi

action=$1
branch=$2
remote_flag=$3  # Optional: -r

case "$action" in
    create)
        # Create a new branch and switch to it
        git checkout -b "$branch"
        git push --set-upstream origin "$branch"
        ;;
    delete)
        # Delete the branch locally
        git branch -D "$branch"

        # If -r is provided, delete it remotely
        if [ "$remote_flag" == "-r" ]; then
            git push origin --delete "$branch"
        fi
        ;;
    merge)
        # Switch to main and merge the branch
        git checkout "$remote_master"
        git merge "$branch"

        # If -r is provided, push changes to remote
        if [ "$remote_flag" == "-r" ]; then
            git push origin "$remote_master"
        fi
        ;;
    *)
        echo "Invalid action. Use create, delete, or merge."
        usage
        ;;
esac

echo "Action '$action' completed successfully for branch '$branch'."
