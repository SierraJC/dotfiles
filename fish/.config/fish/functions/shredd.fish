function shredd \
    --description 'Shred and delete file' \
    --argument-names filename

    if type -q shred
        shred -vfz -n 3 -u $filename
    else
        set filesize (stat -f%z $filename)
        for i in (seq 3)
            dd if=/dev/urandom of=$filename bs=$filesize count=1 conv=notrunc
        end
        dd if=/dev/zero of=$filename bs=$filesize count=1 conv=notrunc
        rm -f $filename
    end
end
