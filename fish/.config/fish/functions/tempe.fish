function tempe \
    --description 'Temporary working directory' \
    --argument-names subfolder

    cd (mktemp -d)
    chmod -R 700 .
    if test -n "$subfolder"
        mkdir -p $subfolder
        cd $subfolder
        chmod -R 700 .
    end
end
