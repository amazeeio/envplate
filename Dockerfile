# syntax=docker/dockerfile:1
# Build ep from scratch
FROM golang:1.25-alpine AS go-builder

ARG VERSION=v1.0.4-rc.1

# Pinning at https://github.com/kreuzwerker/envplate/commit/ec00ede3ca03c6bbbe0412bf4b84eacdcdabba11
ADD https://github.com/kreuzwerker/envplate.git#ec00ede3ca03c6bbbe0412bf4b84eacdcdabba11 /build

WORKDIR /build

RUN go mod download -json

# Build the ep executable
RUN CGO_ENABLED=0 go build -ldflags '-X main.buildVersion=${VERSION} -extldflags "-static"' -o ep ./bin/ep.go

FROM alpine:3.23

LABEL org.opencontainers.image.title="envplate" \
    org.opencontainers.image.description="A simple tool for managing environment variables" \
    org.opencontainers.image.url="https://github.com/amazeeio/envplate" \
    org.opencontainers.image.source="https://github.com/amazeeio/envplate.git" \
    org.opencontainers.image.authors="packaged by amazee.io, original work by kreuzwerker/PCG <hello@pcg.io>" \
    org.opencontainers.image.licenses="GPL-2.0"

# Install ep from build stage
COPY --from=go-builder /build/ep /usr/local/bin/ep

ENTRYPOINT ["/usr/local/bin/ep"]
