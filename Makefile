#===============================================================================
#
#     Filename: Makefile
#  Description:
#
#        Usage: make              (generate executable                      )
#               make clean        (remove objects, executable, prerequisits )
#               make tarball      (generate compressed archive              )
#               make zip          (generate compressed archive              )
#
#      Version: 1.0
#      Created:
#     Revision: ---
#
#       Author:
#      Company:
#        Email:
#
#        Notes: This is a GNU make (gmake) makefile.
#               C   extension   :  c
#               C++ extensions  :  cc cpp C
#               C and C++ sources can be mixed.
#               Prerequisites are generated automatically; makedepend is not
#               needed (see documentation for GNU make Version 3.80, July 2002,
#               section 4.13). The utility sed is used.
#========================================== makefile template version 1.8 ======

# DEBUG can be set to YES to include debugging info, or NO otherwise
DEBUG          := NO

# PROFILE can be set to YES to include profiling info, or NO otherwise
PROFILE        := NO

# ------------  name of the executable  ----------------------------------------
EXECUTABLE      := zte-client

# ------------  list of all source files  --------------------------------------
SOURCES         := eap_protocol.cpp  zte.cpp main.cpp

# ------------  compiler  ------------------------------------------------------
ifeq ($(PF),rg100a)
CC              := openwrt-gcc-rg100a
CXX             := openwrt-g++-rg100a
else
ifeq ($(PF),hg255d)
CC              := openwrt-gcc-hg255d
CXX             := openwrt-g++-hg255d
else
CC              := gcc
CXX             := g++
endif
endif

# ------------  compiler flags  ------------------------------------------------
DEBUG_CFLAGS    := -w -O0 -g
RELEASE_CFLAGS  := -w -O2

# ------------  linker flags  --------------------------------------------------
DEBUG_LDFLAGS    := -g
RELEASE_LDFLAGS  :=

ifeq (YES, ${DEBUG})
  CFLAGS       := ${DEBUG_CFLAGS}
  CXXFLAGS     := ${DEBUG_CXXFLAGS}
  LDFLAGS      := ${DEBUG_LDFLAGS}
else
  CFLAGS       := ${RELEASE_CFLAGS}
  CXXFLAGS     := ${RELEASE_CXXFLAGS}
  LDFLAGS      := ${RELEASE_LDFLAGS}
endif

ifeq (YES, ${PROFILE})
  CFLAGS       := ${CFLAGS}   -pg -O3
  CXXFLAGS     := ${CXXFLAGS} -pg -O3
  LDFLAGS      := ${LDFLAGS}  -pg
endif

# ------------  additional system include directories  -------------------------
GLOBAL_INC_DIR  =

# ------------  private include directories  -----------------------------------
LOCAL_INC_DIR   = 

# ------------  system libraries  (e.g. -lm )  ---------------------------------
SYS_LIBS        = -lpcap

# ------------  additional system library directories  -------------------------
GLOBAL_LIB_DIR  =

# ------------  additional system libraries  -----------------------------------
GLOBAL_LIBS     =

# ------------  private library directories  -----------------------------------
LOCAL_LIB_DIR   = 

# ------------  private libraries  (e.g. libxyz.a )  ---------------------------
LOCAL_LIBS      =

# ------------  archive generation ---------------------------------------------
TARBALL_EXCLUDE = *.{o,gz,zip}
ZIP_EXCLUDE     = *.{o,gz,zip}

# ------------  run executable out of this Makefile  (yes/no)  -----------------
# ------------  cmd line parameters for this executable  -----------------------
EXE_START       = no
EXE_CMDLINE     =

#===============================================================================
# The following statements usually need not to be changed
#===============================================================================

C_SOURCES       = $(filter     %.c, $(SOURCES))
CPP_SOURCES     = $(filter-out %.c, $(SOURCES))
ALL_INC_DIR     = $(addprefix -I, $(LOCAL_INC_DIR) $(GLOBAL_INC_DIR))
ALL_LIB_DIR     = $(addprefix -L, $(LOCAL_LIB_DIR) $(GLOBAL_LIB_DIR))
GLOBAL_LIBSS    = $(addprefix $(GLOBAL_LIB_DIR)/, $(GLOBAL_LIBS))
LOCAL_LIBSS     = $(addprefix $(LOCAL_LIB_DIR)/, $(LOCAL_LIBS))
ALL_CFLAGS      = $(CFLAGS) $(ALL_INC_DIR)
ALL_LFLAGS      = $(LDFLAGS) $(ALL_LIB_DIR)
BASENAMES       = $(basename $(SOURCES))

# ------------  generate the names of the object files  ------------------------
OBJECTS         = $(addsuffix .o,$(BASENAMES))

# ------------  make the executable (the default goal)  ------------------------
$(EXECUTABLE):	$(OBJECTS)
ifeq ($(strip $(CPP_SOURCES)),)
								$(CC)  $(ALL_LFLAGS) -o $(EXECUTABLE) $(OBJECTS) $(LOCAL_LIBSS) $(GLOBAL_LIBSS) $(SYS_LIBS)
else
								$(CXX) $(ALL_LFLAGS) -o $(EXECUTABLE) $(OBJECTS) $(LOCAL_LIBSS) $(GLOBAL_LIBSS) $(SYS_LIBS)
endif
ifeq ($(EXE_START),yes)
								./$(EXECUTABLE) $(EXE_CMDLINE)
endif

# ------------  include the automatically generated prerequisites  -------------
# ------------  if target is not clean, tarball or zip             -------------
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),tarball)
ifneq ($(MAKECMDGOALS),zip)
include         $(PREREQUISITES)
endif
endif
endif

# ------------  make the objects  ----------------------------------------------
%.o:		%.c
				$(CC)  -c $(ALL_CFLAGS) $<

%.o:		%.cc
				$(CXX) -c $(ALL_CFLAGS) $<

%.o:		%.cpp
				$(CXX) -c $(ALL_CFLAGS) $<

%.o:		%.C
				$(CXX) -c $(ALL_CFLAGS) $<

#  canned command sequences

# ------------  remove generated files  ----------------------------------------
# ------------  remove hidden backup files  ------------------------------------
clean:
								-rm -v  $(EXECUTABLE) $(OBJECTS) $(PREREQUISITES) *~

# ------------ tarball generation ----------------------------------------------
tarball:
					@lokaldir=`pwd`; lokaldir=$${lokaldir##*/}; \
					rm --force $$lokaldir.tar.gz;               \
					tar --exclude=$(TARBALL_EXCLUDE)            \
					    --create                                \
					    --gzip                                  \
					    --verbose                               \
					    --file  $$lokaldir.tar.gz *

# ------------ zip -------------------------------------------------------------
zip:
					@lokaldir=`pwd`; lokaldir=$${lokaldir##*/}; \
					zip -r  $$lokaldir.zip * -x $(ZIP_EXCLUDE)

install: $(EXECUTABLE)
				@./install /usr/local/bin

uninstall:
				-rm /usr/local/bin/$(EXECUTABLE) /usr/local/bin/runruijie


.PHONY: clean tarball zip

# ==============================================================================
# vim: set tabstop=2: set shiftwidth=2:
