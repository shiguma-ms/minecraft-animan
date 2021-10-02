kubectl create secret generic mc-secret `
--from-literal=ICOS_APIKEY=ここにICOSのパスワード `
--dry-run=client -o yaml > mc-secret.yaml
