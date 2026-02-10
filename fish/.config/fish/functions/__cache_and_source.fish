function __cache_and_source \
    --argument-names cache_file cache_cmd

    set -l cache_path $__fish_cache_dir/$cache_file

    if not test -f $cache_path
        eval $cache_cmd >$cache_path
    end

    source $cache_path
end

function __cache_clear \
    --description "Clear all cache files"

    rm -f $__fish_cache_dir/*.fish
end
