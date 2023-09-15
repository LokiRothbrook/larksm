#
# 'make'        build executable file 'main'
# 'make clean'  removes all build files
#

# define target
TARGET := larksm

# define the compiler to use
CXX = g++

# define any compile-time flags
CXXFLAGS := -std=c++17 -Wall -Wextra -g

# define library paths in addition to /usr/lib
LFLAGS := 

# define rPath
RPATH := -Wl,-rpath,../lib,-rpath,./lib/

# define build directory
BUILD_DIR := build

# define source directory
SRC_DIR := src

# define objs directory
OBJ_DIR := obj

# define include directory
INCLUDE_DIR := include

# define library directory
LIB_DIR := lib

ifeq ($(OS),Windows_NT)
TARGET_EXEC	 := $(TARGET).exe
SRC_DIRS	 := $(SRC_DIR)
INCLUDE_DIRS := $(INCLUDE_DIR)
LIB_DIRS	 := $(LIB_DIR)
FIXPATH = $(subst /,\,$1)
RM			:= del /q /f
MD	:= mkdir
else
TARGET_EXEC	:= $(TARGET).out
SRC_DIRS	:= $(shell find $(SRC_DIR) -type d)
INCLUDE_DIRS	:= $(shell find $(INCLUDE_DIR) -type d)
LIB_DIRS		:= $(shell find $(LIB_DIR) -type d)
FIXPATH = $1
RM = rm -rf
MD	:= mkdir -p
endif

# define any directories containing header files other than /usr/include
INCLUDES	:= $(patsubst %,-I%, $(INCLUDE_DIRS:%/=%))

# define the libs
LIBS		:= $(patsubst %,-L%, $(LIB_DIRS:%/=%))

# define the source files
SRCS		:= $(wildcard $(patsubst %,%/*.cpp, $(SRC_DIRS)))

# define objects
OBJS := $(SRCS:%=$(OBJ_DIR)/%.o)

# define deps
DEPS := $(OBJS:.o=.d)

# define target path
TARGET_PATH := $(call FIXPATH,$(BUILD_DIR)/$(TARGET_EXEC))

all: $(BUILD_DIR) $(OBJ_DIR) $(BUILD_DIR)/$(TARGET_EXEC)
	@echo Executing all complete!

$(BUILD_DIR):
	$(MD) $(BUILD_DIR)

$(OBJ_DIR):
	$(MD) $(OBJ_DIR)

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(TARGET_PATH) $(OBJS) $(LFLAGS) $(LIBS) $(RPATH)

# include all .d files
-include $(DEPS)

$(OBJ_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c -MMD -MP $< -o $@

.PHONY: clean
clean:
	$(RM) $(BUILD_DIR)
	$(RM) $(OBJ_DIR)