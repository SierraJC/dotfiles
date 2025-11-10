function mkcd \
    --description 'Make and change directory' \
    --argument-names path

    mkdir -p $path; and cd $path
end
