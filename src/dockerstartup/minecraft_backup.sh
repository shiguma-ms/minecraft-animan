#! /bin/bash

if [ ! ${EUID:-${UID}} = 0 ]; then
    "Please root user exec."
    exit 1
fi

if [ -d "/data/world" ]; then

    # タイムスタンプ取得
    timestamp=$(date '+%y-%m-%d-%H-%M-%S')

    filename_prefix="world-backup-"

    filename=${filename_prefix}${timestamp}".tar.zst"

    # バックアップ実行
    tar -cf ${filename} --use-compress-program=zstd /data/world

    filepath=$(readlink -f ./${filename})

    # バックアップ転送

    # 認証トークン取得
    json=$(curl -s -X "POST" "https://iam.cloud.ibm.com/identity/token" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        --data-urlencode "apikey=${ICOS_APIKEY}" \
        --data-urlencode "response_type=cloud_iam" \
        --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey")
    token=$(echo ${json} | jq -r '.["access_token"]')
    # アップロード
    curl -s -X "PUT" "https://${ICOS_ENDPOINT}/${ICOS_BUCKET}/${filename}" \
    -H "Authorization: bearer ${token}" \
    --upload-file ${filepath}

    sleep 5

    # 最新のバックアップとしてもコピー
    curl -s -X "PUT" "https://${ICOS_ENDPOINT}/${ICOS_BUCKET}/${filename_prefix}latest.tar.zst" \
    -H "Authorization: bearer ${token}" \
    -H "x-amz-copy-source: /${ICOS_BUCKET}/${filename}"

    # バックアップファイル削除
    rm ${filepath}

fi

exit 0