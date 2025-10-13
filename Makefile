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

.PHONY: all clean
