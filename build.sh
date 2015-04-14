#!/bin/sh

set -e
set -x

mkdir -p $HOME/.matplotlib
cat > $HOME/.matplotlib/matplotlibrc <<EOF
    # ZYV
    backend : svg
EOF

if [ "$xMPI" = "x" ] ; then
   export LD_LIBRARY_PATH="/usr/lib/openmpi/lib:$LD_LIBRARY_PATH"
   export CPATH="/usr/lib/openmpi/include:$CPATH"
   export PATH="/usr/include/mpi:$PATH"
   
   cat > $HOME/.nestrc <<EOF
    % ZYV: NEST MPI configuration
    /mpirun
    [/integertype /stringtype]
    [/numproc     /slifile]
    {
     () [
      (mpirun -np ) numproc cvs ( ) statusdict/prefix :: (/bin/nest )  slifile
     ] {join} Fold
    } Function def
EOF
 
    CONFIGURE_MPI="--with-mpi"

else
    CONFIGURE_MPI="--without-mpi"
fi

if [ "$xPYTHON" = "x" ] ; then
    CONFIGURE_PYTHON="--with-python"
else
    CONFIGURE_PYTHON="--without-python"
fi

if [ "$xGSL" = "x" ] ; then
    CONFIGURE_GSL="--with-gsl"
else
    CONFIGURE_GSL="--without-gsl"
fi

./bootstrap.sh

mkdir build result
NEST_RESULT=$(readlink -f result)
cd build

../configure \
    --prefix="$NEST_RESULT"  \
    CC=mpicc CXX=mpic++ \
    $CONFIGURE_MPI \
    $CONFIGURE_PYTHON \
    $CONFIGURE_GSL \

make
make install
make installcheck
