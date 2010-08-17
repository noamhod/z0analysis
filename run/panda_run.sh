#!/bin/bash/

# remove the arlier outputs
rm -f input.txt
rm -f z0analysis.root

# get the latest grl and cut flow
cp -f cutFlow.cuts
cp -f Z_GRL_152844-159224.xml

# submit the panda run
#prun --exec "echo %IN > input.txt; root.exe analysisGridControlRun.C;" --athenaTag=15.6.9 --outDS user.hod.z0analysis.WZphys.Aug17 --outputs z0analysis.root --inDS group10.phys-sm.data10_7TeV.0015*.physics_MuonswBeam.*.WZphys.*.D3PD  --nFiles 10

#prun --exec "echo %IN > input.txt; root.exe analysisGridControlRun.C;" --athenaTag=15.6.9 --outDS user.hod.z0analysis.WZphys.Aug17.time1246 --outputs z0analysis.root --inDS group10.phys-sm.data10_7TeV.00159224.physics_MuonswBeam.recon.ESD.x30.WZphys.100612.02.D3PD  --nFiles 10 --extFile analysisGridControl_C.so

prun --exec "echo %IN > input.txt; root.exe analysisGridControlRun.C; .L analysisGridControl_C.so; analysisGridControl agc(fChain, fout); agc.loop(0,0);" --athenaTag=15.6.9 --outDS user.hod.z0analysis.WZphys.Aug17.time1246 --outputs z0analysis.root --inDS group10.phys-sm.data10_7TeV.00159224.physics_MuonswBeam.recon.ESD.x30.WZphys.100612.02.D3PD  --nFiles 10 --extFile analysisGridControl_C.so

