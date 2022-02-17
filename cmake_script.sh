#!/bin/bash -l

set -x
# RUN THESE MODULE COMMAND BEFORE YOU START!
module unload PrgEnv-pgi
module unload PrgEnv-pathscale
module unload PrgEnv-intel
module unload PrgEnv-cray
module unload cray-trilinos

module unload cray-libsci
module unload cray-tpsl
module unload cray-tpsl-64
module unload cray-netcdf
module unload PrgEnv-gnu
module unload gcc
module unload cmake
module unload cray-hdf5
module unload cray-netcdf-hdf5parallel

module load gcc/9.2.0
module load PrgEnv-gnu/6.0.10
module load cray-tpsl/20.03.2
module load cmake/3.20.1

export PATH=$PATH:/opt/cray/pe/tpsl/20.03.2/GNU/8.2/haswell/lib
export PATH=$PATH:/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/lib

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cray/pe/tpsl/20.03.2/GNU/8.2/haswell/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/lib


echo "Setup and compilation"
echo "of Elmer on Cray"
echo "on" date
echo "-------------------------"
echo "Following modules loaded:"
module list
echo "-------------------------"
# necessary declarations
export Hypre_LIBRARIES="-lm"
export Hypre_INCLUDE_DIR=" "
export Mumps_LIBRARIES="-lm"
export Mumps_INCLUDE_DIR=" "
CRAY_ADD_RPATH=yes
export CRAYPE_LINK_TYPE=dynamic
CMAKE=cmake


# Directories (set these!)
ELMERSRC="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem"
BUILDDIR="$ELMERSRC/build"

# get GIT-tag and construct installation name from it
TIMESTAMP=$(date +"%m-%d-%y")
ELMER_REV="Elmer_devel_${TIMESTAMP}"
IDIR="/lustre/f2/dev/gfdl/Alexander.Huth/$ELMER_REV"

# next line is optional, for toolchain file for x-compilation to CNL-target
TOOLCHAIN="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/cmake/Toolchains/toolchain.cmake"

echo "Building Elmer from within " ${BUILDDIR}
echo "using following toolchain file " ${TOOLCHAIN}
echo "installation into: " ${IDIR}
echo "-------------------------"
cd ${BUILDDIR}
pwd
ls -ltr

rm -r CMakeFiles CMakeCache.txt
#make clean

echo $CMAKE $ELMERSRC

# configure it
$CMAKE -Wno-dev $ELMERSRC \
    -DCMAKE_INSTALL_PREFIX=$IDIR \
    -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
    -DWITH_MPI:BOOL=TRUE \
    -DWITH_OpenMP:BOOL=TRUE \
    -DWITH_Mumps:BOOL=TRUE \
    -DWITH_Hypre:BOOL=TRUE \
    -DWITH_NETCDF:BOOL=TRUE \
    -DWITH_ELMERGUI:BOOL=FALSE \
    -DWITH_ElmerIce:BOOL=TRUE \
    -DWITH_ScatteredDataInterpolator:BOOL=TRUE \
    -DWITH_Trilinos:BOOL=TRUE \
    -DWITH_Zoltan:Bool=TRUE \
    -DUSE_SYSTEM_ZOLTAN:Bool=TRUE \
    -DTRILINOS_PATH:STRING="/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64" \
    -DEpectra_INCLUDE_DIRS:STRING="/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/include" \
    -DML_INCLUDE_DIRS:STRING="/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/include" \
    -DZOLTAN_INCLUDE_DIR="/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/include" \
    -DZOLTAN_LIBRARY="/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/lib/libzoltan.so" \
    -DSOLTAN_LIBDIR="/opt/cray/pe/trilinos/12.18.1.1/GNU/8.2/x86_64/lib" \
    -DHypre_LIBRARIES="-lm" \
    -DHypre_INCLUDE_DIR=" "\
    -DMumps_LIBRARIES="-lm" \
    -DMumps_INCLUDE_DIR=" "\
    -DNETCDF_INCLUDE_DIR:STRING="/opt/cray/pe/netcdf/4.7.4.4/GNU/8.2/include" \
    -DNETCDF_LIBRARY:STRING="/opt/cray/pe/netcdf/4.7.4.4/GNU/8.2/lib/libnetcdf.so" \
    -DNETCDFF_LIBRARY:STRING="/opt/cray/pe/netcdf/4.7.4.4/GNU/8.2/lib/libnetcdff.so" \
    -DCSA_LIBRARY:STRING="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/scattered2Dinterpolator/install/lib/libcsa.a" \
    -DCSA_INCLUDE_DIR:STRING="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/scattered2Dinterpolator/install/include" \
    -DNN_INCLUDE_DIR:STRING="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/scattered2Dinterpolator/install/include" \
    -DNN_LIBRARY:STRING="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/scattered2Dinterpolator/install/lib/libnn.a" \
    -DMMG_INCLUDE_DIR:STRING="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/mmg/install/include" \
    -DMMG_LIBRARY:STRING="/lustre/f2/dev/gfdl/Alexander.Huth/elmerfem/mmg/install/lib64/libmmg.a" \
    -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-g -O3"\
    -DCMAKE_C_FLAGS_RELWITHDEBINFO="-g -O3"\
    -DCMAKE_Fortran_FLAGS_RELWITHDEBINFO="-g -O3"


#     -DCMAKE_INSTALL_PREFIX=$IDIR \
#     -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN \
#     -DCMAKE_EXE_LINKER_FLAGS:STRING="-lptesmumps -lptscotch -lptscotcherr -lscotch -lesmumps -fopenmp" \
#     -DCMAKE_MODULE_LINKER_FLAGS:STRING="-lptesmumps -lptscotch -lptscotcherr -lscotch -lesmumps -fopenmp" \
#     -DMPI_Fortran_LINK_FLAGS:STRING= "-Wl,-rpath  -Wl,--enable-new-dtags -lptesmumps -lesmumps -fopenmp" \
echo "Done configuring"
echo "-------------------------"
echo "Starting to build:"

#make && make install
make -j 4 && make install

# compile and install it (last step might be in need of a sudo, perhaps)
# make -j 4 && make install && cp ~/Source/Elmer/Sisu/compilation_sisu_gnuCmake.sh $IDIR && /appl/opt/fix-perms.sh $IDIR
