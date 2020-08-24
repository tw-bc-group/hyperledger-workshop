FABRIC_VERSION    ?= 2.1.1
FABRIC_AC_VERSION ?= 1.4.7
COUCHDB_VERSION   ?= 4.20

PEER	:= ./bin/peer
PWD		:= $(shell pwd)

CC_NAME             ?= fabcar
USE_DOMAIN          ?= 0
VERSION				?= 1
SEQUENCE			?= $(VERSION)
JAVA_SRC_PATH       := chaincode/$(CC_NAME)/java
CC_SRC_PATH         := $(JAVA_SRC_PATH)/build/install/$(CC_NAME)

prepare:
	@echo "use fabric $(FABRIC_VERSION)"
	@echo "use fabric-ac $(FABRIC_AC_VERSION)"
	@echo "use couchdb $(COUCHDB_VERSION)"
	./scripts/bootstrap.sh \
		-s $(FABRIC_VERSION) $(FABRIC_AC_VERSION) $(COUCHDB_VERSION)

compileCC:
	@echo Compile chaincode $(CHAINCODE)
	cd $(JAVA_SRC_PATH) ;\
  ./gradlew installDist

packCC:
	@echo Pack chaincode $(CHAINCODE)
	pushd test-network ; source scripts/envVar.sh ; popd ;\
	FABRIC_CFG_PATH=$(PWD)/config/ \
	$(PEER) lifecycle chaincode package fabcar.tar.gz \
		--path $(CC_SRC_PATH) \
		--lang java \
		--label fabcar_$(VERSION)

deployCC:
	cd test-network ;\
	USE_DOMAIN=$(USE_DOMAIN) \
	SEQUENCE=$(SEQUENCE) \
	./network.sh deployCC -l java -v $(VERSION)
