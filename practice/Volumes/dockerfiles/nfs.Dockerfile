FROM katacoda/contained-nfs-server:centos7
ADD nfs_setup.sh /
RUN chmod a+x /nfs_setup.sh
