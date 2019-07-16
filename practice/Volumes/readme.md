docker run -d \
  --net=host \
  --privileged \
  --name nfs-server \
  -v /exports:/exports \
  sbeliakou/nfs-server \
    /exports/data-0001 \
    /exports/data-0002


