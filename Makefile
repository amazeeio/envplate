VERSION := "1.0.0-rc2"
REPO := envplate
USER := ocean
TOKEN = `cat .token`
FLAGS := "-X=main.build=`git rev-parse --short HEAD` -X=main.version=$(VERSION)"

.PHONY: build clean release retract

build:
	# cd bin && mkdir -p build  && gox -osarch="linux/amd64 linux/arm linux/arm64/v8 linux/arm64 linux/aarch64 darwin/amd64 darwin/arm64" -ldflags $(FLAGS) -output "../build/{{.OS}}-{{.Arch}}/ep-{{.OS}}-{{.Arch}}";
	cd bin && mkdir -p build
	GOOS=linux GOARCH=amd64 LDFLAGS="-X main.Version=$(VERSION) -X main.Build=`git rev-parse --short HEAD` -X main.BuildTime=$(BUILDTIME)" \
		go build -v -o ./bin/build/linux_amd64/ep-linux-amd64 ./bin/ep.go
	GOOS=linux GOARCH=arm LDFLAGS="-X main.Version=$(VERSION) -X main.Build=`git rev-parse --short HEAD` -X main.BuildTime=$(BUILDTIME)" \
		go build -v -o ./bin/build/linux_arm/ep-linux-arm ./bin/ep.go
	GOOS=linux GOARCH=arm64 LDFLAGS="-X main.Version=$(VERSION) -X main.Build=`git rev-parse --short HEAD` -X main.BuildTime=$(BUILDTIME)" \
		go build -v -o ./bin/build/linux_arm64/ep-linux-arm64 ./bin/ep.go
	GOOS=darwin GOARCH=amd64 LDFLAGS="-X main.Version=$(VERSION) -X main.Build=`git rev-parse --short HEAD` -X main.BuildTime=$(BUILDTIME)" \
		go build -v -o ./bin/build/darwin_amd64/ep-darwin-amd64 ./bin/ep.go
	GOOS=darwin GOARCH=arm64 LDFLAGS="-X main.Version=$(VERSION) -X main.Build=`git rev-parse --short HEAD` -X main.BuildTime=$(BUILDTIME)" \
		go build -v -o ./bin/build/darwin_arm64/ep-darwin-arm64 ./bin/ep.go

clean:
	rm -rf bin/build

release:
	git tag $(VERSION) -f && git push --tags -f
	github-release release --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN)
	github-release upload --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN) --name ep-osx --file build/darwin/ep
	github-release upload --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN) --name ep-linux --file build/linux-amd64/ep
	github-release upload --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN) --name ep-linux-arm --file build/linux-arm/ep
	github-release upload --user $(USER) --repo $(REPO) --tag $(VERSION) -s $(TOKEN) --name ep-osx --file build/darwin-amd64/ep

retract:
	github-release delete --tag $(VERSION) -s $(TOKEN)
