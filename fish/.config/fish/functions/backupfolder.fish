function backupfolder \
    --description 'Backup folder to tar.gz' \
    --argument-names folder_name

    set backup_date (date '+%Y-%m-%d')
    tar -zcvf "$folder_name"_"$backup_date".tar.gz "$folder_name"
end
