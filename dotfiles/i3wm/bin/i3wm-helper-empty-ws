#!/usr/bin/env sh

# Echo number of next empty workspace to standard out.

# set -x

# Requires: jq

_jq_query=$(cat <<'EOF'
# Compute last consecutive number in list, plus one.
def first_missing: . as [$first, $second]
    | if ($first + 1 == $second)
        then (.[1:] | first_missing)
        else ($first + 1)
        end;
# Max with 0 so that ws num will always be non-negative.
# Merge [-1] so that we start looking for numbers at zero.
map(.num) + [-1] | unique | first_missing | [., 0] | max
EOF
)

i3-msg -t get_workspaces | jq "${_jq_query}"
