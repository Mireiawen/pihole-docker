FROM "pihole/pihole"

RUN \
        wget "https://github.com/mireiawen/PiHole-Local-DNS-GUI/archive/master.zip" && \
        unzip "master.zip" && \
	pushd "PiHole-Local-DNS-GUI-master" && \
	bash "install.sh" && \
	popd && \
        rm -rf "master.zip" "PiHole-Local-DNS-GUI-master"
