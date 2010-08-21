/* * * * * * * * * * * */
/* created by Naom Hod */
/* noam.hod@cern.ch    */
/* noam.com@gmail.com  */
/* on 23/07/2010 11:24 */
/* * * * * * * * * * * */

#include "basicIncludes.h"

#define kinematics_cxx
#include "kinematics.C"

#ifndef SELECTION_H
#define SELECTION_H

class selection : public kinematics
{
public:
	utilities* m_util;
	
	bool   b_print;
	
	TMapsvd* m_cutFlowMapSVD;
	TMapds*  m_cutFlowOrdered;

public:
	selection();
	~selection();
	
	void sinitialize();
	void sfinalize();

	void initSelectionCuts(TMapsvd* cutFlowMapSVD, TMapds* cutFlowOrdered); // called by analysis, offlineAnalysis and digestAnalysis
	
	// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	// * * * simple cuts methods * * *
	
	bool isGRLCut( double isGRLCutVal, int isGRL );
	bool isL1_MU6Cut( double isL1_MU6CutVal, int isL1_MU6 );
	
	bool pTCut(           double pTCutVal,           TLorentzVector* pa, TLorentzVector* pb );
	bool etaCut(          double etaCutVal,          TLorentzVector* pa, TLorentzVector* pb );
	bool cosThetaDimuCut( double cosThetaDimuCutVal, TLorentzVector* pa, TLorentzVector* pb );
	bool imassCut(        double imassCutVal,        TLorentzVector* pa, TLorentzVector* pb );

	bool d0Cut(          double d0CutVal, double d0a, double d0b ); // deprecated !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	bool z0Cut(          double z0CutVal, double z0a, double z0b ); // deprecated !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	bool oppositeChargeCut( double ca, double cb );
	
	bool prmVtxNtracksCut( double prmVtxNtracksCutVal, int nPVtracks );
	bool prmVtxTypeCut( double prmVtxTypeCutVal, int nPVtype );
	bool prmVtxZ0Cut( double prmVtxZ0CutVal, double dPVz0, double dPVz0err );
	bool isCombMuCut( double isCombMuCutVal, int isCombMu );
	bool nSCThitsCut( double nSCThitsCutVal, int nSCThits );
	bool nPIXhitsCut( double nPIXhitsCutVal, int nPIXhits );
	bool pTmatchLowRatioCut( double pTmatchLowRatioCutVal, double me_qOp, double me_theta,
														   double id_qOp, double id_theta );
	bool pTmatchHighRatioCut( double pTmatchHighRatioCutVal, double me_qOp, double me_theta,
															 double id_qOp, double id_theta );
	bool impcatParamZ0Cut( double impcatParamZ0CutVal, double impPrmZ0);
	bool impcatParamD0Cut( double impcatParamD0CutVal, double impPrmD0 );
	bool isolationXXCut( double isolationCutVal, string sIsoValName, double pTmu, double pTcone );
	
	
	// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	// * * * combined cuts methods * * *
	
	bool primaryVertexCut( double prmVtxNtracksCutVal, double prmVtxTypeCutVal, double prmVtxZ0CutVal,
						   vector<int>* pviPVtracks, vector<int>* pviPVtype, vector<float>* pvfPVz0, vector<float>* pvfPVz0err );
	bool nIDhitsCut( double nSCThitsCutVal, double nPIXhitsCutVal, double nIDhitsCutVal, int nSCThits, int nPIXhits );
	bool pTmatchingCut( double pTmatchLowRatioCutVal, double pTmatchHighRatioCutVal,
						double me_qOp, double me_theta,
						double id_qOp, double id_theta );
	bool impactParameterCut( double impcatParamZ0CutVal, double impcatParamD0CutVal,
							 double impPrmZ0, double impPrmD0 );
	
	// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	
	
	void buildMuonPairMap(	TMapii& mupair,
							double ca, int ia,
							double cb, int ib);

	void buildMuonPairMap(	TMapii& mupair,
							TLorentzVector* pa, double ca, double d0a, double z0a, int ia,
							TLorentzVector* pb, double cb, double d0b, double z0b, int ib );

	bool removeOverlaps(	TMapii& mupair, int ia, int ib );
	void findBestMuonPair(	TMapii& mupair, int& ia, int& ib);

private:

};
#endif

