FROM ubuntu:16.04

# Update and install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update --fix-missing && \
    apt-get install -y automake autotools-dev g++ git libcurl4-gnutls-dev wget libfuse-dev libssl-dev libxml2-dev make pkg-config

# Clone and run s3fs-fuse
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git /tmp/s3fs-fuse && \
    cd /tmp/s3fs-fuse && ./autogen.sh && ./configure && make && make install && ldconfig && /usr/local/bin/s3fs --version

# Remove packages
RUN DEBIAN_FRONTEND=noninteractive apt-get purge -y wget automake autotools-dev g++ git make  && \
    apt-get -y autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set user and group
ENV USER='s3'
ENV GROUP='s3'
ENV UID='1000'
ENV GID='1000'

RUN groupadd -g $GID $GROUP && \
    useradd -u $UID -g $GROUP -s /bin/sh -m $USER

# Install fuse
RUN apt-get update   && \
    apt install fuse && \
    chown ${USER}.${GROUP} /usr/local/bin/s3fs

# Config fuse
RUN chmod a+r /etc/fuse.conf && \
    perl -i -pe 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf

# Copy credentials
ENV SECRET_FILE_PATH=/home/${USER}/passwd-s3fs
COPY ./passwd-s3fs $SECRET_FILE_PATH
RUN chmod 600 $SECRET_FILE_PATH && \
    chown ${USER}.${GROUP} $SECRET_FILE_PATH

# Switch to user
USER ${UID}:${GID}


# Create mnt point
ENV MNT_POINT_PATH=/home/${USER}
RUN mkdir -p $MNT_POINT_PATH && \
    chmod g+w $MNT_POINT_PATH

# Execute
WORKDIR /home/${USER}
COPY mount.sh /home/s3/mount.sh
CMD exec sleep 100000