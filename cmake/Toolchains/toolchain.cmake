#
# CMake toolchain file for building with GNU compilers
#

SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR x86_64)
SET(CMAKE_SYSTEM_VERSION 1)

# Specify the cross compilers (serial)
SET(CMAKE_C_COMPILER cc)
SET(CMAKE_Fortran_COMPILER ftn)
SET(CMAKE_CXX_COMPILER CC)

# Specify the cross compilers (parallel)
SET(MPI_C_COMPILER cc)
SET(MPI_CXX_COMPILER CC)
SET(MPI_Fortran_COMPILER ftn)

# Compilation flags (i.e. with optimization)
SET(CMAKE_C_FLAGS "-O2 -fPIC -lptesmumps -lptscotch -lptscotcherr -lscotch -lesmumps" CACHE STRING "")
SET(CMAKE_CXX_FLAGS "-O2 -fPIC -lptesmumps -lptscotch -lptscotcherr -lscotch -lesmumps" CACHE STRING "")
SET(CMAKE_Fortran_FLAGS "-O2 -fPIC -lptesmumps -lptscotch -lptscotcherr -lscotch -lesmumps" CACHE STRING "")

# Reset the default build type flags, all flags should be set above
SET(CMAKE_C_FLAGS_RELWITHDEBINFO "" CACHE STRING "")
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "" CACHE STRING "")
SET(CMAKE_Fortran_FLAGS_RELWITHDEBINFO "" CACHE STRING "")

# Compilation flags for native build using C compiler, used for ElmerGrid
#SET(NATIVE_BUILD_FLAGS "-g -fPIC" CACHE STRING "")
#SET(NATIVE_BUILD_FLAGS "-g -fPIC -target-cpu=broadwell" CACHE STRING "")
SET(NATIVE_BUILD_FLAGS "-g -fPIC -target-cpu=haswell" CACHE STRING "")
#SET(NATIVE_BUILD_FLAGS "-g -fPIC -target-cpu=sandybridge" CACHE STRING "")

# Path of Blas and Lapack
# BLAS and LAPACK libraries are included in the wrappers,
# so we just link in libm to make cmake happy
SET(BLAS_LIBRARIES "m" CACHE STRING "")
SET(LAPACK_LIBRARIES "m" CACHE STRING "")

# Set the result of GFortran version test for cross compiling
SET( GFORTRAN_VERSIONTEST_RUN_RESULT 
     "0"
     CACHE STRING "Result from TRY_RUN" FORCE)

SET( GFORTRAN_VERSIONTEST_RUN_RESULT__TRYRUN_OUTPUT 
     "9.2.0"
     CACHE STRING "Output from TRY_RUN" FORCE)
SET ( MPIEXEC "srun" CACHE STRING "")
SET ( MPIEXEC_NUMPROC_FLAG  "-n" CACHE STRING "")
