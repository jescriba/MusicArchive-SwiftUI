build:
	@xcodegen

test: build
	@set -o pipefail && xcodebuild -workspace MusicArchive.xcworkspace -scheme MusicArchiveTests -destination "platform=iOS Simulator,name=iPhone 11 Pro" build test | xcpretty

ci_bootstrap:
	@bin/brew_install.sh xcodegen
	@bundle install --quiet
	@$(MAKE) build

inc-build:
	@bin/inc_build_number.sh

bootstrap:
	@bin/brew_install.sh xcodegen swiftformat
	@bin/githooks/install.sh
	@$(MAKE) build

.PHONY: bootstrap \
				ci_bootstrap \
				build \
				inc-build \
				test
