test:
	flutter test

build:
	flutter build apk --release

deploy:
	flutter test && git add . && git commit -m "deploy" && git push