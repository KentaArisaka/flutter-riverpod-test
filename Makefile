.PHONY: get setup sort

get:
	fvm flutter clean
	fvm flutter pub get

setup:
	fvm install
	fvm flutter clean
	fvm flutter pub get

sort:
	fvm dart run import_sorter:main --no-comments
