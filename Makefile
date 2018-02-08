#-------------------------------------------------------------------------------
#  Top level makefile for XXXXXX
#
#  Dependencies: '/bin/sh', 'g++', 'gcc'
#
#  'make all' builds all XXXX code in base directory
#
#  'make check' checks for the existance of the XXXXX dependencies
#
#  'make clean' removes *.o *~ core* and executable files
#
#  'make pack' creates a gzipped tarfile of the XXXXX directories
#
#-------------------------------------------------------------------------------
SHELL = /bin/sh
VERSION := 1.0


TOP_DIR     := $(CURDIR)
BIN_DIR     := $(TOP_DIR)

SRC_DIR  := $(TOP_DIR)/src/

CC   := $(filter /%,$(shell /bin/sh -c 'type gcc'))
CXX  := $(filter /%,$(shell /bin/sh -c 'type g++'))
AR   := $(filter /%,$(shell /bin/sh -c 'type ar'))

GCCMAJORVERSION := $(shell expr `gcc -dumpversion | cut -f1 -d.` \>= 4)
GCCMINORVERSION := $(shell expr `gcc -dumpversion | cut -f2 -d.` \>= 5)


#CXXFLAGS = -fopenmp -D_GLIBCXX_PARALLEL -std=c++14 -mpopcnt -DNO_REHASH -DVECTOR
CXXFLAGS = -fopenmp -D_GLIBCXX_PARALLEL -std=c++14 -march=native -mtune=native -mpopcnt -DUINT64 -flto
CXXFLAGS_SERIAL = -DSERIAL
CXXFLAGS_NO_REHASH =  -DNO_REHASH

CXXPROF = -g -gdwarf-3 -pg 
CXXDEBUG = -g -gdwarf-3 -Wall -Wextra -Wunused -Wuninitialized -DDEBUG 
CXXOPTIMIZE = -O3 -fomit-frame-pointer
#LDFLAGS  = -lz -L/home/nkhiste/work/EFENCE/electric-fence-2.1.13 -lefence
ifeq ($(MAKECMDGOALS),debug)
        LDFLAGS  = -lz -rdynamic 
else
        LDFLAGS  = -lz 
endif

FLATS = INSTALL LICENSE Makefile README 



#-- EXPORT THESE VARIABLES TO OTHER MAKEFILES
export BIN_DIR CXX CXXFLAGS CC CFLAGS LDFLAGS

ifeq ($(MAKECMDGOALS),debug)
        CXXFLAGS += $(CXXDEBUG)
else ifeq ($(MAKECMDGOALS),profile)
        CXXFLAGS += $(CXXPROF)
else ifeq ($(MAKECMDGOALS),serial)
        CXXFLAGS = $(CXXDEBUG)
        CXXFLAGS += $(CXXFLAGS_SERIAL)
else ifeq ($(MAKECMDGOALS),noRehash)
        CXXFLAGS += $(CXXFLAGS_NO_REHASH)
        CXXFLAGS += $(CXXOPTIMIZE)
else
        CXXFLAGS += $(CXXOPTIMIZE)
endif



#-- PHONY rules --#
.PHONY: all check clean pack


all: check build_src 

debug: check build_src 

profile: check build_src 

serial: check build_src 

noRehash: check build_src 


check:
ifndef TOP_DIR
	@echo "ERROR: could not find working directory"; exit 1;
endif
ifndef CXX
	@echo "ERROR: 'g++' GNU C++ compiler not found"; exit 1;
endif
ifndef CC
        @echo "ERROR: 'gcc' GNU C compiler not found"; exit 1;
endif
ifndef AR
	@echo "ERROR: 'ar' GNU archiver not found"; exit 1;
endif
#ifneq "$(GCCMAJORVERSION)" "1"
#	@echo "ERROR: Incompatible GCC version. Need GCC 4.5 or higher"; exit 1;
#else ifneq "$(GCCMINORVERSION)" "1"
#	@echo "ERROR: Incompatible GCC version. Need GCC 4.5 or higher"; exit 1;
#endif
	@echo "Basic check complete"


clean:
	cd $(SRC_DIR); $(MAKE) clean
	rm -f *.o *~ core*

build_src:
	cd $(SRC_DIR); $(MAKE) hisea


pack: DISTDIR = XXXXXX$(VERSION)
pack:
	mkdir $(DISTDIR)
	cp -r src $(DISTDIR)
	cp $(FLATS) $(DISTDIR)
	tar -cvf $(DISTDIR).tar $(DISTDIR)
	gzip $(DISTDIR).tar
	rm -rf $(DISTDIR)

#-- END OF MAKEFILE --#
