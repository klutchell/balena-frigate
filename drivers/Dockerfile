FROM alpine:3.12

WORKDIR /usr/src/app

# hadolint ignore=DL3018
RUN apk add --no-cache kmod

COPY run.sh gasket ./

RUN chmod +x ./run.sh

CMD [ "/usr/src/app/run.sh" ]
