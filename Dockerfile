# You're probably wondering why I didn't just use klakegg/hugo:0.71.0-ext-alpine
# Well that "Truly minimal" image is 552 MB. This one is 70.6 MB
FROM alpine:3.11@sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54

# config
ENV HUGO_VERSION=0.71.0
ENV HUGO_TYPE=_extended
ENV HUGO_DOWNLOAD="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo${HUGO_TYPE}_${HUGO_VERSION}_Linux-64bit.tar.gz"

# Add requiremnts for Hugo
RUN apk add --no-cache \
  # ca-certificates are required to fetch outside resources (like Twitter oEmbeds)
  ca-certificates \
  # libc6-compat & libstdc++ are required for extended SASS libraries
  # see: https://github.com/gohugoio/hugo/blob/master/Dockerfile#L33
  libc6-compat \
  libstdc++ \
  # Needed for getting post update dates out of git commits
  git

# Install Hugo
RUN mkdir -p /tmp/hugo \
    && wget "${HUGO_DOWNLOAD}" -O /tmp/hugo/hugo.tar.gz \
    && tar xvf /tmp/hugo/hugo.tar.gz -C /usr/sbin/ hugo \
    && rm -rf /tmp/hugo

WORKDIR /src

CMD ["/src/docker/hugo_serve.sh"]
