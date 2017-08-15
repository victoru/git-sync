FROM golang:1.7-alpine

ENV ARCH="amd64"
ENV PKG=k8s.io/git-sync

ADD . /go/src/k8s.io/git-sync
WORKDIR /go/src/k8s.io/git-sync

RUN apk --no-cache add git \
	&& VERSION=$(git describe --tags --always --dirty) ./build/build.sh

FROM alpine:3.4

ENV GIT_SYNC_DEST /git

COPY --from=0 /go/bin/git-sync /git-sync

RUN apk update --no-cache && apk add \
	ca-certificates \
	coreutils \
	git \
	openssh-client

USER nobody:nobody
ENTRYPOINT ["/git-sync"]
