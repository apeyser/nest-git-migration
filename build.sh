#!/bin/sh

set -e
set -x

mkdir -p $HOME/.matplotlib
cat > $HOME/.matplotlib/matplotlibrc <<EOF
    # ZYV
    backend : svg
EOF

if [ "$xMPI" = "MPI+" ] ; then

    # Fedora
   # module load mpi/openmpi-i386
   
   #export PATH="$PATH:/home/$USER/.openmpi/bin"
   #export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/$USER/.openmpi/lib/"
   ls /usr/include/openmpi
   ls /usr/include/openmpi/openmpi
   ls /usr/include/mpi
   ls /usr/lib/openmpi
   
   ls /usr/local/mpi/openmpi
   
   #/home/travis/build/INM-6/nest-git-migration/
   #export PATH="$PATH:/usr/include/.openmpi/bin"
   #export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/.openmpi/lib/"
   export PATH="$PATH:/usr/include/openmpi/bin"
   export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/openmpi/lib/"
   
   #mpich2
   export LD_LIBRARY_PATH="/usr/lib/mpich2/lib:$LD_LIBRARY_PATH"
   export CPATH="/usr/include/mpich2:$CPATH"
   #openmpi
   export LD_LIBRARY_PATH="/usr/lib/openmpi/lib:$LD_LIBRARY_PATH"
   export CPATH="/usr/lib/openmpi/include:$CPATH"
   
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

if [ "$xPYTHON" = "Python+" ] ; then
    CONFIGURE_PYTHON="--with-python"
else
    CONFIGURE_PYTHON="--without-python"
fi

if [ "$xGSL" = "GSL+" ] ; then
    CONFIGURE_GSL="--with-gsl"
else
    CONFIGURE_GSL="--without-gsl"
fi

./bootstrap.sh

NEST_VPATH=build
NEST_RESULT=result

mkdir "$NEST_VPATH" "$NEST_RESULT"

NEST_RESULT=$(readlink -f $NEST_RESULT)

cd "$NEST_VPATH"

../configure \
    --prefix="$NEST_RESULT" \
    $CONFIGURE_MPI \
    $CONFIGURE_PYTHON \
    $CONFIGURE_GSL \


make
make install
make installcheck
