darkhttpd /usr/local/aria2/AriaNg --port 8080 & \
#/root/.aria2/tracker.sh && \
/usr/local/bin/aria2c  \
    --conf-path=$ARIA2_DIR/aria2.conf \
    --input-file=$ARIA2_DIR/aria2.session \
    --save-session=$ARIA2_DIR/aria2.session \
    --dht-file-path=$ARIA2_DIR/dht.dat \
    --dht-file-path6=$ARIA2_DIR/dht6.dat \
    --on-download-stop=$ARIA2_DIR/delete.sh \
    --on-download-complete=$ARIA2_DIR/delete.aria2.sh
