CFLAGS = -I ./inc/ -I ./dep/inc/ -L ./dep/lib/ -lportaudio -O3
CWARNS = -Wall -Wextra -Wno-unused-parameter -Wno-unused-command-line-argument

SRC_DIR = src
BUILD_DIR = build

# Detect OS
ifeq ($(OS),Windows_NT)
    LIB_NAME = libcaudio.lib
    MKDIR = if not exist "$(1)" mkdir "$(1)"
    RM = if exist "$(1)" del /Q "$(1)"
    FIXPATH = $(subst /,\,$1)
else
    LIB_NAME = libcaudio.a
    MKDIR = mkdir -p $(1)
    RM = rm -rf $(1)
    FIXPATH = $1
endif

SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

LIBRARY = $(BUILD_DIR)/$(LIB_NAME)

all: $(LIBRARY)

$(LIBRARY): $(OBJECTS)
	@$(call MKDIR,$(@D))
	ar rcs $@ $(OBJECTS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@$(call MKDIR,$(@D))
	$(CC) $(CFLAGS) $(CWARNS) -c $< -o $@

clean:
	$(call RM,$(BUILD_DIR))

.PHONY: all clean
