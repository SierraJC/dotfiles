function mksh \
    --description 'Create new bash script' \
    --argument-names script_name

    if test (count $script_name) -ne 1
        echo 'mksh takes one argument' 1>&2
        exit 1
    else if test -e $script_name
        echo "$script_name already exists" 1>&2
        exit 1
    end

    echo '#!/usr/bin/env bash
set -euo pipefail

' >$script_name

    chmod u+x $script_name

    $EDITOR $script_name
end
