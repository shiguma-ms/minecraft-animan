#! /bin/bash

if [ -n "${RESTORE}" ]; then
    if [ "${RESTORE}" = "TRUE" ]; then
        # バックアップに使用するファイル名
        filename="world-backup-latest.tar.zst"

        # 旧ワールドデータをバックアップに移動し元を削除
        if [ -d "/data/world" ]; then
            mkdir -p /data/backup
            filename_prefix="world-backup-"
            timestamp=$(date '+%y-%m-%d-%H-%M-%S')
            backup_filename=${filename_prefix}${timestamp}".tar.zst"
            tar -cf ${backup_filename} --use-compress-program=zstd /data/world
            mv ${backup_filename} /data/backup/${backup_filename}
            rm -rf /data/world
        fi

        cd /
        # 認証トークン取得
        json=$(curl -s -X "POST" "https://iam.cloud.ibm.com/identity/token" \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/x-www-form-urlencoded' \
            --data-urlencode "apikey=${ICOS_APIKEY}" \
            --data-urlencode "response_type=cloud_iam" \
            --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey")
        token=$(echo ${json} | jq -r '.["access_token"]')

        # ダウンロード
        curl -sO "https://${ICOS_ENDPOINT}/${ICOS_BUCKET}/${filename}" \
            -H "Authorization: bearer ${token}"

        tar -xf ${filename} --use-compress-program=zstd
        rm ${filename}
        chown -R minecraft.minecraft /data
        cd /data
    fi
fi

# minecraft起動
/start
