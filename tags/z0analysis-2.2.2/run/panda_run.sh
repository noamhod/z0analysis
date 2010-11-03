#!/bin/bash/

#####################################################################################################
################################ view the job progress in: ##########################################
###### http://panda.cern.ch:25980/server/pandamon/query?ui=register&name=Noam%20Hod&reload=yes ######
#####################################################################################################

# ARGUMENT 1:
#   run type
mcordata=$1
if [ "$mcordata" = "mc" ] ; then
   echo "MC run"
elif [ "$mcordata" = "data" ] ; then
   echo "DATA run"
else
   exit
fi

# ARGUMENT 2:
#   run number
runnumber=$2
# ARGUMENT 3:
#   dataset name
datasetname=$3



# the GRL version
grlvs=00-00-84


# add to LD_LIBRARY_PATH
ispwdld=`echo $LD_LIBRARY_PATH | grep $PWD`
if [ "$ispwdld" = "" ] ; then
   export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$PWD
fi
isgrlld=`echo $LD_LIBRARY_PATH | grep $PWD/GoodRunsLists-$grlvs/StandAlone`
if [ "$isgrlld" = "" ] ; then
   export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$PWD/GoodRunsLists-$grlvs/StandAlone
fi


# date
dateandhour=`date +d%d%m%Y.h%H%M`


# remove the arlier outputs
rm -f input.txt
rm -f z0analysis.root
rm -f Loader_C.so

# get the latest grl and cut flow
cp -u ../conf/cutFlow.cuts .
cp -u ../conf/dataPeriods.data .
cp -u ../conf/Z_GRL_CURRENT.xml .


# make usable
chmod 777 cutFlow.cuts
chmod 777 dataPeriods.data
chmod 777 Z_GRL_CURRENT.xml


# submit the panda run with a single dataset using --writeInputToTxt
if [ "$mcordata" = "mc" ] ; then
   prun --exec "root.exe -b -q mcAnalysisGridControlRun.C;" --writeInputToTxt IN:input.txt  --athenaTag=15.6.9 --outDS user.hod.mcWZphys.$runnumber.$dateandhour  --outputs mcWZphys.root --inDS $datasetname  --extFile mcAnalysisGridControl_C.so, Loader_C.so, ../GoodRunsLists-00-00-84/StandAlone/libGoodRunsLists.so --workDir ../  --tmpDir /tmp/hod/prun_info --nGBPerJob=10
elif [ "$mcordata" = "data" ] ; then
   prun --exec "root.exe -b -q analysisGridControlRun.C;" --writeInputToTxt IN:input.txt  --athenaTag=15.6.9 --outDS user.hod.WZphys.$runnumber.$dateandhour  --outputs WZphys.root --inDS $datasetname  --extFile analysisGridControl_C.so, Loader_C.so, ../GoodRunsLists-00-00-84/StandAlone/libGoodRunsLists.so --workDir ../  --tmpDir /tmp/hod/prun_info
else
   exit
fi

#prun --exec "root.exe -b -q analysisGridControlRun.C;" --writeInputToTxt IN:input.txt  --athenaTag=15.6.9 --outDS user.hod.WZphys.$runnumber.$dateandhour  --outputs WZphys.root --inDS $datasetname  --extFile analysisGridControl_C.so, Loader_C.so, ../GoodRunsLists-00-00-84/StandAlone/libGoodRunsLists.so --workDir ../  --tmpDir /tmp/hod/prun_info

#prun --site WISC_GROUP --exec "root.exe -b -q analysisGridControlRun.C;" --writeInputToTxt IN:input.txt  --athenaTag=15.6.9 --outDS user.hod.WZphys.$runnumber.$dateandhour  --outputs WZphys.root --inDS $datasetname  --extFile analysisGridControl_C.so, Loader_C.so, ../GoodRunsLists-00-00-84/StandAlone/libGoodRunsLists.so --workDir ../  --tmpDir /tmp/hod/prun_info

# or, submit the panda run with a single dataset using shell echo command (can handle up to 200 files)
#prun --exec "echo %IN > input.txt;  root.exe analysisGridControlRun.C;" --athenaTag=15.6.9 --outDS user.hod.z0analysis.$dateandhour --outputs z0analysis.root --inDS group10.phys-sm.data10_7TeV.00159224.physics_MuonswBeam.recon.ESD.x30.WZphys.100612.02.D3PD  --extFile analysisGridControl_C.so, ../GoodRunsLists-00-00-84/StandAlone/libGoodRunsLists.so --workDir ../

# submit the panda run with a single dataset, using only 10 of its files
#prun --exec "echo %IN > input.txt;  root.exe analysisGridControlRun.C;" --athenaTag=15.6.9 --outDS user.hod.z0analysis.$dateandhour --outputs z0analysis.root --inDS group10.phys-sm.data10_7TeV.00159224.physics_MuonswBeam.recon.ESD.x30.WZphys.100612.02.D3PD   --extFile analysisGridControl_C.so, ../GoodRunsLists-00-00-84/StandAlone/libGoodRunsLists.so --workDir ../  --nFiles 10

# submit the panda run with multiple datasets
