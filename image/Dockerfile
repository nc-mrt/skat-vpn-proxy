FROM frolvlad/alpine-gcc as base

COPY pw-input /pw-input
RUN cd /pw-input && cc -o pw pw.c

FROM alpine:edge

EXPOSE 8080

COPY app /app
COPY --from=base /pw-input/pw /pw
RUN set -xe \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ openconnect expect privoxy runit\
    && apk update \
    && apk -i upgrade \
    && touch /mnt/vars.config \
    && find /app -name run | xargs chmod u+x\
    && find /app -type f | xargs dos2unix
    
CMD ["runsvdir", "/app"]