##############################################
### MAKEFILE FOR VLSV PARALLEL FILE FORMAT ###
###                                        ###
###    Make a copy of this file and edit   ###
###     include and library paths below    ###
##############################################

# Compiler and its flags. Leave FLAGS empty, it is 
# meant to use from make command line to override 
# the values set here.
CMP = mpic++
CXXFLAGS = -O3 -std=c++0x
FLAGS =

# Archiver
AR = ar

# Include and library paths (edit these if necessary)
INC_SILO=-I/home/sandroos/codes/silo/silo-4.7.1/include
LIB_SILO=-L/home/sandroos/codes/silo/silo-4.7.1/lib -lsilo

# Distribution package name (do not edit)
DIR=vlsv
DIST=vlsv_v01_000.tar

# Build targets

default: lib

clean:
	rm -rf *~ *.o *.a *.tar *.tar.gz vlsv2silo

dist:
	ln -s ${CURDIR} ${DIR}
	tar -rf ${DIST} ${DIR}/COPYING* ${DIR}/Makefile
	tar -rf ${DIST} ${DIR}/*.h ${DIR}/*.cpp ${DIR}/*.pdf
	gzip -9 ${DIST}
	rm ${DIR}

# Dependencies

DEPS_COMMON = muxml.h vlsv_common.h
DEPS_MUXML = muxml.h muxml.cpp
DEPS_VLSVCOMMON = vlsv_common.h vlsv_common.cpp
DEPS_READER = ${DEPS_VLSCOMMON} vlsvreader.h vlsvreader2.cpp
DEPS_WRITER = ${DEPS_VLSCOMMON} vlsvwriter.h vlsvwriter2.cpp
DEPS_VLSV2SILO = vlsvreader.o muxml.o vlsv_common.o vlsv2silo.cpp

OBJS=muxml.o vlsv_common.o vlsvreader.o vlsvwriter.o

# Build rules

lib: ${OBJS}
	${AR} r libvlsv.a ${OBJS}
	make vlsv2silo

muxml.o: ${DEPS_MUXML}
	${CMP} ${CXXFLAGS} ${FLAGS} -o muxml.o -c muxml.cpp

vlsv_common.o: ${DEPS_VLSVCOMMON}
	${CMP} ${CXXFLAGS} ${FLAGS} -o vlsv_common.o -c vlsv_common.cpp

vlsvreader.o: ${DEPS_READER}
	${CMP} ${CXXFLAGS} ${FLAGS} -o vlsvreader.o -c vlsvreader2.cpp

vlsvwriter.o: ${DEPS_WRITER}
	${CMP} ${CXXFLAGS} ${FLAGS} -o vlsvwriter.o -c vlsvwriter2.cpp

vlsv2silo: ${DEPS_VLSV2SILO}
	${CMP} ${CXXFLAGS} ${FLAGS} -o vlsv2silo vlsv2silo.cpp ${INC_SILO} -L${CURDIR} -lvlsv ${LIB_SILO}
