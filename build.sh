#!/bin/sh

set -e
set -x

mkdir -p $HOME/.matplotlib
cat > $HOME/.matplotlib/matplotlibrc <<EOF
    # ZYV
    backend : svg
EOF

    CONFIGURE_MPI="--without-mpi"
    CONFIGURE_PYTHON="--with-python"
    CONFIGURE_GSL="--without-gsl"

./bootstrap.sh

NEST_VPATH=build
NEST_RESULT=result

mkdir "$NEST_VPATH" "$NEST_RESULT"

NEST_RESULT=$(readlink -f $NEST_RESULT)

cd "$NEST_VPATH"

../configure \
    --prefix="$NEST_RESULT"  CC=mpicc CXX=mpic++ \
    $CONFIGURE_MPI \
    $CONFIGURE_PYTHON \
    $CONFIGURE_GSL \


make
make install
make installcheck
ls /home/travis/build/INM-6/nest-git-migration/build/reports
cat /home/travis/build/INM-6/nest-git-migration/build/reports/TEST-core.phase_2.xml
if [ "$xMPI" = "MPI+" ] ; then
  cat /home/travis/build/INM-6/nest-git-migration/build/reports/TEST-core.phase_5.xml
fi  
