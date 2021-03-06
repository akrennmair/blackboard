DART_SRC=$(wildcard *.dart)
JS_SRC=$(patsubst %.dart,%.dart.js,$(DART_SRC))
GOBIN=blackboard
GOSRC=$(wildcard *.go)

all: $(JS_SRC) $(GOBIN)

%.dart.js: %.dart
	$$DART_SDK/bin/dart2js -o $@ $<

$(GOBIN): $(GOSRC)
	go build -o $@

clean:
	$(RM) $(JS_SRC) $(GOBIN) *.deps *.map *.precompiled.js

