# Envplate - amazee.io builder

This version of Envplate builds from the upstream releases at https://github.com/kreuzwerker/envplate to configure an up-to-date Dockerfile build for ease of reuse.

The original version is still available at https://github.com/kreuzwerker/envplate

# envplate (Docker Repackaged)

This repository provides a repackaged Docker image for [`kreuzwerker/envplate`](https://github.com/kreuzwerker/envplate), a Docker-friendly trivial templating for configuration files using environment keys.

## About

- **Upstream Source:** [kreuzwerker/envplate](https://github.com/kreuzwerker/envplate)
- **Docker Image:** Built from the upstream source, with no functional changes to the application itself. The Docker image may be built using updated versions of Golang as appropriate for security and compatibility.
- **Purpose:** This repo automates the build and packaging of envplate as a Docker image, suitable for use in CI/CD pipelines, Kubernetes, and other containerized platforms.

## Usage

Pull or build the Docker image:

```bash
# Build locally
docker build -t local/envplate:latest .
# Or use your preferred Docker build command
```

Run the container:

```bash
docker run --rm local/envplate:latest --help
```

You can mount your own config files or configuration as needed:

```bash
docker run --rm -v $(pwd)/config.template:/config.template \
    -e DB_HOST=localhost -e DB_USER=admin \
    local/envplate:latest -v /config.template
```

## Testing

This repository includes a comprehensive BATS test suite for integration, CLI, HTTP, signal, and Docker-based tests. All tests run against the Docker image to ensure container compatibility.

- See `envplate.bats` for details on running the test suite.

## License

This repository is licensed under MIT License (MIT). See `LICENSE` for details.

## Credits

- Original authors: [kreuzwerker/envplate](https://github.com/kreuzwerker/envplate)
- This repackaged Docker image and test suite are maintained by the amazee.io team.

## Disclaimer

This repository is not affiliated with or endorsed by the original authors. All credit for the application itself goes to the upstream maintainers. This repo only repackages the software for containerized environments and provides additional testing and automation. Where sustainable, the versions of golang used to build the image may be updated.
