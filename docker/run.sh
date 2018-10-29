nginx &

sed -e "s/%WEBSOCKET_TOKEN%/$WEBSOCKET_TOKEN/" evb_flow.json.template > /data/evb_flow.json

touch /log/restore-log
grep sakura.io /data/evb_flow.json
npm start -- --userDir /data
