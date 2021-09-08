FROM alpine:3.12

RUN apk add --no-cache kmod

COPY run.sh /

RUN chmod +x /run.sh

CMD [ "/run.sh" ]
