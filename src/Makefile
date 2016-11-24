#-- Imported variables from top level makefile
# BIN_DIR CXX CC CFLAGS CXXFLAGS LDFLAGS

ifndef BIN_DIR
BIN_DIR := $(CURDIR)
LOCAL_CXX := -std=c++0x -fopenmp 
LDFLAGS := -lz 
ERR := 1
endif

UTIL_DIR := $(CURDIR)/Util
ALGO_DIR := $(CURDIR)/Algorithm
GZSTREAM_DIR := $(CURDIR)/ThirdParty/gzstream

INCLUDE_DIR :=  -IUtil -IThirdParty/gzstream -IAlgorithm 


OBJ_RULE = $(CXX) $(LOCAL_CXX) $(CXXFLAGS) $(INCLUDE_DIR) $< -c -o $@
BIN_RULE = $(CXX) $(LOCAL_CXX) $(CXXFLAGS) $(INCLUDE_DIR) $^ $(LDFLAGS) -o $@; \
           chmod 755 $@; mv $@ $(BIN_DIR)/.;

ALL := hisea


#-- PHONY rules --#
.PHONY: all clean err

err:  
ifdef ERR
	@echo :: WARNING! Please use root level Makefile for this code compilation ...
endif

all: $(ALL) 

clean:
	rm -f *.o *~ $(ALL)
	cd $(BIN_DIR); rm -f $(ALL)


#-- not so PHONY rules --#

SequenceReader.o: $(UTIL_DIR)/SequenceReader.cpp 
	$(OBJ_RULE)

KmerMap.o: $(ALGO_DIR)/KmerMap.cpp 
	$(OBJ_RULE)

Alignment.o: $(ALGO_DIR)/Alignment.cpp 
	$(OBJ_RULE)

MemoryTracker.o: $(UTIL_DIR)/MemoryTracker.cpp 
	$(OBJ_RULE)

gzstream.o: $(GZSTREAM_DIR)/gzstream.C 
	$(OBJ_RULE)

Globals.o: $(UTIL_DIR)/Globals.cpp 
	$(OBJ_RULE)

Options.o: $(UTIL_DIR)/Options.cpp  
	$(OBJ_RULE)

hisea: Hisea.cpp Globals.o Options.o SequenceReader.o MemoryTracker.o gzstream.o KmerMap.o Alignment.o
	$(BIN_RULE)


