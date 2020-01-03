.PHONY: update

update:
	ifconfig  en0 | grep 'inet ' | awk '{print $$2}' > pub/ip.txt && \
	ghr --delete --prerelease -u yubo -r doc v1 pub
