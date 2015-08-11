CC := g++
CFLAGS := -std=c++11 -g -Wall -O3 -Iinclude
CPPFLAGS := $(CFLAGS)
LIBS := -pthread -lsqlite3 -Llib -Wl,-rpath=lib

SRV_EXE := server/server.out
CLI_EXE := client/client.out
EXE := $(SRV_EXE) $(CLI_EXE)

SRV_SRC = $(wildcard server/*.cpp)
CLI_SRC = $(wildcard client/*.cpp)
COM_SRC = $(wildcard common/*.cpp)
SRC = $(SRV_SRC) $(CLI_SRC) $(COM_SRC)

SRV_OBJ = $(SRV_SRC:.cpp=.o)
CLI_OBJ = $(CLI_SRC:.cpp=.o)
COM_OBJ = $(COM_SRC:.cpp=.o)
OBJ = $(SRV_OBJ) $(CLI_OBJ) $(COM_OBJ)

all: depend $(EXE)

.PHONY: all

$(SRV_EXE): $(SRV_OBJ) $(COM_OBJ)
	$(CC) $(CPPFLAGS) $^ -o $@ $(LIBS)
$(CLI_EXE): $(CLI_OBJ) $(COM_OBJ)
	$(CC) $(CPPFLAGS) $^ -o $@ $(LIBS)
depend:
	$(CC) -MM $(SRC) > .depend
-include .depend
clean:
	@rm -f $(EXE) $(OBJ) .depend
