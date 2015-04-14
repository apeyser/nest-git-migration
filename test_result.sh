#!/bin/sh

ls /home/travis/build/INM-6/nest-git-migration/build/reports
cat /home/travis/build/INM-6/nest-git-migration/build/reports/TEST-core.phase_2.xml
if [ "$xMPI" = "MPI+" ] ; then
  cat /home/travis/build/INM-6/nest-git-migration/build/reports/TEST-core.phase_5.xml
fi  
