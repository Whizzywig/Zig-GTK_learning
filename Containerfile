FROM alpine:3.18 AS build-stage
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing --repository http://dl-cdn.alpinelinux.org/alpine/edge/main zig gtk4.0-dev

WORKDIR /app
COPY . .
RUN zig build

FROM scratch AS export-stage
COPY --from=build-stage /app/zig-cache/bin /