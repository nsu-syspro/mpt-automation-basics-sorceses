# Получаем значения из config.json
NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

# Директории
SRC_DIR := src
BUILD_DIR := build
SRC := $(SRC_DIR)/wordcount.c
TARGET := $(BUILD_DIR)/$(NAME)

# Компилятор и флаги
CC := gcc
CFLAGS := -Wall -Wextra
DEFINES := -DNAME=\"$(NAME)\" -DVERSION=\"$(VERSION)\"

# Основная цель
all: $(TARGET)

# Сборка целевого приложения
$(TARGET): $(SRC) config.json | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(DEFINES) -o $@ $<

# Создание директории build если её нет
$(BUILD_DIR):
	mkdir -p $@

# Очистка артефактов сборки
clean:
	rm -rf $(BUILD_DIR)

# Отслеживание изменений в config.json
$(SRC): config.json

# Тестирование
TEST_DIR := test
TESTS := $(wildcard $(TEST_DIR)/*.txt)

check: $(TARGET) $(TESTS)
	@echo "Running tests..."
	@for test in $(TESTS); do \
		test_name=$$(basename "$$test" .txt); \
		expected="$(TEST_DIR)/$$test_name.expected"; \
		actual="$(TEST_DIR)/$$test_name.actual"; \
		./$(TARGET) < "$$test" > "$$actual" 2>&1; \
		if ! diff -u "$$expected" "$$actual" > /dev/null 2>&1; then \
			echo "Test $$test_name failed:"; \
			diff -u "$$expected" "$$actual" || true; \
			rm -f "$$actual"; \
			exit 1; \
		fi; \
		rm -f "$$actual"; \
	done
	@echo "All tests passed!"
.PHONY: all clean check
