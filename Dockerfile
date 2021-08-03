# Build docker-gen from scratch
FROM golang:1.16-alpine as ep-builder

LABEL org.opencontainers.image.authors="tobybellwood" maintainer="tobybellwood"
LABEL org.opencontainers.image.source="https://github.com/tobybellwood/envplate" repository="https://github.com/tobybellwood/envplate"

ARG VERSION=main

WORKDIR /build

# Install the dependencies
COPY . .
RUN go mod download -json

# Build the docker-gen executable
RUN CGO_ENABLED=0 go build -ldflags '-X main.buildVersion=${VERSION} -extldflags "-static"' -o ep ./bin/ep.go

FROM alpine:3.13

# Install docker-gen from build stage
COPY --from=ep-builder /build/ep /usr/local/bin/ep

ENTRYPOINT ["/usr/local/bin/ep"]