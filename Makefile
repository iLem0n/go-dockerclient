ifeq "$(strip $(shell go env GOARCH))" "amd64"
RACE_FLAG := -race
endif

.PHONY: test
test: pretest gotest

.PHONY: golangci-lint
golangci-lint:
	cd /tmp && GO111MODULE=on go get github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	golangci-lint run

.PHONY: staticcheck
staticcheck:
	cd /tmp && GO111MODULE=on go get honnef.co/go/tools/cmd/staticcheck@master
	staticcheck ./...

.PHONY: lint
lint: golangci-lint staticcheck

.PHONY: pretest
pretest: lint

.PHONY: gotest
gotest:
	go test $(RACE_FLAG) -vet all ./...

.PHONY: integration
integration:
	go test -tags docker_integration -run TestIntegration -v
