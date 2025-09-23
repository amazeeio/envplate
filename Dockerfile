# syntax=docker/dockerfile:1
# Build docker-gen from scratch
FROM golang:1.25-alpine AS ep-builder

ARG VERSION=v1.0.4-rc.1

# Pinning at https://github.com/kreuzwerker/envplate/commit/ec00ede3ca03c6bbbe0412bf4b84eacdcdabba11
ADD https://github.com/kreuzwerker/envplate.git#ec00ede3ca03c6bbbe0412bf4b84eacdcdabba11 /build

WORKDIR /build

RUN go mod download -json

# Build the docker-gen executable
RUN CGO_ENABLED=0 go build -ldflags '-X main.buildVersion=${VERSION} -extldflags "-static"' -o ep ./bin/ep.go

FROM scratch

# Install docker-gen from build stage
COPY --from=ep-builder /build/ep /usr/local/bin/ep

ENTRYPOINT ["/usr/local/bin/ep"]
