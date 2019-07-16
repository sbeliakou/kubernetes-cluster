#!/bin/bash
mkdir -p /exports
for mnt in "$@"; do
  mkdir -p $mnt
  chown nfsnobody:nfsnobody $mnt
  chmod 777 $mnt
  echo "$(dirname $mnt) *(rw,sync,no_root_squash,fsid=0)" >> /etc/exports
  echo "$mnt *(rw,sync,no_root_squash)" >> /etc/exports
done

exportfs -avr
rpcbind
rpc.statd
rpc.nfsd

exec rpc.mountd --foreground
