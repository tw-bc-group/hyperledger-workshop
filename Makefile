FABRIC_VERSION ?= 2.1.1
FABRIC_AC_VERSION ?= 1.4.7
COUCHDB_VERSION ?= 4.20

prepare:
	@echo "use fabric $(FABRIC_VERSION)"
	@echo "use fabric-ac $(FABRIC_AC_VERSION)"
	@echo "use couchdb $(COUCHDB_VERSION)"
	./scripts/bootstrap.sh -s $(FABRIC_VERSION) $(FABRIC_AC_VERSION) $(COUCHDB_VERSION)
