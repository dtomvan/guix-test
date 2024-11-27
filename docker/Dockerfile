FROM alpine:latest AS base

################################################################################

FROM base AS builder

ENV PATH /var/guix/profiles/per-user/root/current-guix/bin:$PATH

RUN apk add --no-cache ca-certificates curl
# COPY sha256sums /tmp
RUN cd /tmp
RUN set -eux; \
	curl -fsSLO https://ftpmirror.gnu.org/gnu/guix/guix-binary-1.4.0.x86_64-linux.tar.xz; \
	# sha256sum -c --ignore-missing --status < sha265sums \
	tar xJf guix-binary-1.4.0.x86_64-linux.tar.xz; \
	rm guix-binary-1.4.0.x86_64-linux.tar.xz

RUN addgroup guixbuild
RUN addgroup guix-builder
RUN chgrp guix-builder -R /gnu/store
RUN chmod 1775 /gnu/store

RUN mkdir -p /root/.config/guix/
COPY channels.scm /root/.config/guix/
RUN set -eux; \
	mv var/guix /var/ && mv gnu /; \
	builders=10 ;\
	for i in `seq 1 $builders` ; do \
	  adduser -S guix-builder$i guix-builder ;\
	  adduser guix-builder$i guix-builder ;\
	done; \
	sh -c "guix-daemon --build-users-group=guix-builder --disable-chroot &" \
	&& guix archive --authorize < /var/guix/profiles/per-user/root/current-guix/share/guix/ci.guix.gnu.org.pub \
	&& guix archive --authorize < /var/guix/profiles/per-user/root/current-guix/share/guix/berlin.guix.gnu.org.pub \
    && guix pull --url="https://github.com/Foundation-Devices/guix-mirror" \
    && guix package --upgrade                                              \
    && guix gc                                                             \
    && guix gc --optimize

################################################################################

FROM base AS environment

ENV PATH /root/.guix-profile/bin:$PATH

COPY --from=builder /var/guix /var/guix
COPY --from=builder /gnu /gnu

RUN apk add --no-cache bash doas

RUN ln -sf /var/guix/profiles/per-user/root/current-guix /root/.guix-profile

RUN addgroup guixbuild
RUN addgroup guix-builder
RUN adduser -S user guix-builder
RUN adduser user wheel
RUN mkdir -p /home/guix-builder /etc/doas.d/
COPY doas.conf /etc/doas.d/doas.conf
RUN chmod 640 /etc/doas.d/doas.conf

COPY wrapper.sh /home/user/wrapper.sh
USER user
WORKDIR /home/user
CMD ./wrapper.sh
