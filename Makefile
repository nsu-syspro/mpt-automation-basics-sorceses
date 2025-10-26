NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC_DIR := src
BUILD_DIR := build
TEST_DIR := test
SRC := $(SRC_DIR)/wordcount.c
TARGET := $(BUILD_DIR)/$(NAME)

CC := gcc
CFLAGS := -Wall -Wextra
DEFINES := -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

TESTS := $(wildcard $(TEST_DIR)/*.txt)
TEST_RESULTS := $(TESTS:.txt=.result)

all: $(TARGET)

$(TARGET): $(SRC) config.json | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(DEFINES) -o $@ $<

$(BUILD_DIR):
	mkdir -p $@

$(TEST_RESULTS): %.result: %.txt $(TARGET)
	@test_name=$$(basename "$<" .txt); \
	expected="$(TEST_DIR)/$$test_name.expected"; \
	actual="$(TEST_DIR)/$$test_name.actual"; \
	./$(TARGET) < "$<" > "$$actual" 2>&1; \
	if ! diff -u "$$expected" "$$actual" > /dev/null 2>&1; then \
		echo "Test $$test_name failed:"; \
		diff -u "$$expected" "$$actual" || true; \
		rm -f "$$actual"; \
		exit 1; \
	fi; \
	rm -f "$$actual"; \
	touch $@

check: $(TEST_RESULTS)

clean:
	rm -rf $(BUILD_DIR)
	rm -f $(TEST_RESULTS)

$(SRC): config.json

.PHONY: all clean check
